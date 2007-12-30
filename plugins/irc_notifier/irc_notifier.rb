


class IrcNotifier
  attr_accessor :nickname, :server, :port, :realname, :chatroom

  def initialize(project = nil)
    @nickname = ''
    @server = ''
    @port = ''
    @realname = ''
    @chatroom = ''

  end

  def connect
 
    CruiseControl::Log.debug("IRC notifier: connecting to #{@server}") 

    network = IRC::Models::Network.new(:name => "ccrb")
    @channel = network.create_channel(@chatroom)
    @server = network.create_server(@server, @port)
    
    # Initialize the connection connection.
    @connection = IRC::Client::Connection.new(@nickname, @nickname, @realname)
    
    Timeout::timeout(IRC::Client::Connection::MAX_CONNECTION_TIMEOUT_IN_SEC) do
      @connection.connect(@server)    
      while !@connection.connected? do sleep 0.1; end
    end
    
    # Wait until the connection is registered.
    Timeout::timeout(10) do
      @connection.register
      while !@connection.registered? do sleep 0.1; end
    end
  
    Timeout::timeout(10) do
      @connection.join(@chatroom)
      while !@connection.joined?(@chatroom) do sleep 0.1 end
    end    
    
  end

  def disconnect
    CruiseControl::Log.debug("IRC notifier: disconnecting from #{@server}")
    Timeout::timeout(10) do
      @connection.disconnect
      while @connection.connected? do sleep 0.1; end
    end
  end

  def reconnect
    disconnect
    connect
  end

  def connected?
    @connection.respond_to?(:registered?) && @connection.registered?
  end

  def build_finished(build)
    if build.failed?
      notify_of_build_outcome(build)
    end
  end

  def build_fixed(fixed_build, previous_build)
    notify_of_build_outcome(fixed_build)
  end

  def notify_of_build_outcome(build)
    if @server==''
      CruiseControl::Log.debug("IRC notifier: IRC server is not defined")
    else
      status = build.failed? ? "broken" : "fixed"
      message = "#{build.project.name} Build #{build.label} - #{status.upcase}"
      if Configuration.dashboard_url
        message += ". See #{build.url}"
      end
      CruiseControl::Log.debug("IRC notifier: sending 'build #{status}' notice")
      notify(message)
    end
  end

  def notify(message)
    connect unless connected?
      CruiseControl::Log.debug("IRC notifier: sending notice: '#{message}'")
      @connection.send_command("notice #{@chatroom} :" + message)
  end

end
