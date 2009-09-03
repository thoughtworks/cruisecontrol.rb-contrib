# Developed By Emerson Macedo (http://github.com/emerleite - http://codificando.com)
#
# Send twitter notifications when build fail or fix
#
# 1. Configure Twitter account to broadcast messages:
# <pre><code>Project.configure do |project|
#   ...
#   project.twitter_notifier.username = "youruser"
#   project.twitter_notifier.password = "yourpassword"
#   ...
# end</code></pre>

class TwitterNotifier < BuilderPlugin
  attr_writer :username
  attr_writer :password

  def initialize(project = nil)
  end

  def build_finished(build)
    return if @username.empty? or @password.empty? or not build.failed?
    tweet build, "#{build.project.name} build #{build.label} failed"
  end

  def build_fixed(build, previous_build)
    return if @username.empty? or @password.empty?
    tweet build, "#{build.project.name} build #{build.label} fixed"
  end

  private

  def tweet(build, message)
    httpauth = Twitter::HTTPAuth.new(@username, @password)
    base = Twitter::Base.new(httpauth)
    base.update(message)
    CruiseControl::Log.event("Build tweet to #{@username} - #{message}", :debug)
  rescue => e
    CruiseControl::Log.event("Error while tweet to #{@username}", :error)
    raise
  end

end

Project.plugin :twitter_notifier
