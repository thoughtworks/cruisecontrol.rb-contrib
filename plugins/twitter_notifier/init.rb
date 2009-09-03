$LOAD_PATH << File.join(File.dirname(__FILE__), 'vendor','twitter-0.6.11','lib')
$LOAD_PATH << File.dirname(__FILE__)

require 'twitter'
require 'twitter_notifier'

Project.plugin :twitter_notifier
