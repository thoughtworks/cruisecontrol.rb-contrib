$LOAD_PATH << File.dirname(__FILE__)

require 'lib/campfire_notifier'

Project.plugin :campfire_notifier
