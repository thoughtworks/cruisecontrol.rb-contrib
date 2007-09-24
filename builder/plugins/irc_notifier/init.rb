$LOAD_PATH << File.join(File.dirname(__FILE__), 'vendor','ircguerilla-irc-1.3.0','lib')
$LOAD_PATH << File.dirname(__FILE__)

#require 'stringio'
require 'irc/client/context'
require 'irc/client/disconnected_state'
require 'irc/models/network'
require 'timeout'
require 'irc_notifier'

Project.plugin :irc_notifier
