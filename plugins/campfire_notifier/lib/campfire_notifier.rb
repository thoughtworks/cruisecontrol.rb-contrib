begin
  require 'tinder' 
rescue LoadError
  CruiseControl::Log.fatal("Campfire notifier: Unable to load 'tinder' gem.")
  CruiseControl::Log.fatal("Install the tinder gem with: sudo gem install tinder")
  exit
end

class CampfireNotifier < BuilderPlugin
  attr_accessor :subdomain, :room, :username, :password, :campfire

  def initialize(project = nil)
  end

  def connect
    CruiseControl::Log.debug("Campfire notifier: connecting to #{@subdomain}")
    @campfire = Tinder::Campfire.new(@subdomain)
    CruiseControl::Log.debug("Campfire notifier: authenticating user: #{@username}")
    begin
      @campfire.login(@username, @password)
    rescue Tinder::Error
      CruiseControl::Log.warn("Campfire notifier: login failed, unable to notify")
      return false
    end

    CruiseControl::Log.debug("Campfire notifier: finding room: #{@room}")
    @chat_room = @campfire.find_room_by_name(@room)
  end

  def disconnect
    CruiseControl::Log.debug("Campfire notifier: disconnecting from #{@subdomain}")
    @campfire.logout if defined?(@campfire) && @campfire.logged_in?
  end

  def reconnect
    disconnect
    connect
  end

  def connected?
    defined?(@campfire) && @campfire.logged_in?
  end

  def build_finished(build)
    notify(build) if build.failed?
  end

  def build_fixed(fixed_build, previous_build)
    notify(fixed_build)
  end

  private
    def notification_message(build)
      status = build.failed? ? "broken" : "fixed"
      message = "#{build.project.name} Build #{build.label} - #{status.upcase}"
      if Configuration.dashboard_url
        message += ". See #{build.url}"
      end
      message
    end

    def notify(build)
      message = notification_message(build)
      
      if connect
        begin
          CruiseControl::Log.debug("Campfire notifier: sending notice: '#{message}'")
          @chat_room.speak(message)
        ensure
          disconnect rescue nil
        end
      else
        CruiseControl::Log.warn("Campfire notifier: couldn't connect to send notice: '#{message}'")
      end
    end
end
