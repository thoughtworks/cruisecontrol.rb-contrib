#!/usr/bin/env ruby
# 
# Copyright (c) 2006 Roman Scherer | IRC Guerilla | Rapid Packet Movement
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# $Id: ping_command.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/commands/command'
require 'irc/commands/invalid_command'
require 'irc/messages/error_message'
require 'irc/messages/pong_message'

module IRC
  
  module Commands
    
    # 4.6.2 Ping message
    # 
    # Command: 	    PING
    # Parameters: 	<server1> [<server2>]
    # 
    # The PING message is used to test the presence of an active client at the other end of 
    # the connection. A PING message is sent at regular intervals if no other activity detected 
    # coming from a connection. If a connection fails to respond to a PING command within a set 
    # amount of time, that connection is closed.
    # 
    # Any client which receives a PING message must respond to <server1> (server which sent the 
    # PING message out) as quickly as possible with an appropriate PONG message to indicate it 
    # is still there and alive. Servers should not respond to PING commands but rely on PINGs 
    # from the other end of the connection to indicate the connection is alive. If the <server2> 
    # parameter is specified, the PING message gets forwarded there.
    # 
    # Numeric Replies:
    # * ERR_NOORIGIN 	
    # * ERR_NOSUCHSERVER
    # 
    # Examples:
    # 
    # PING tolsun.oulu.fi  ; server sending a PING message to
    #                      another server to indicate it is still
    #                      alive.
    # 
    # PING WiZ             ; PING message being sent to nick WiZ
    # 
    class PingCommand < Command
      
      attr_reader :first_server
      attr_reader :second_server      
      
      def initialize(first_server, second_server = nil)
        raise InvalidCommand.new("Can't create ping command. No server.") unless first_server
        @first_server, @second_server = first_server, second_server
        super(command)              
      end
      
      # Returns the command as a string.
      def command
        return "PING #{first_server} #{second_server != nil ? second_server.to_s : ''}".strip
      end
      
      # Returns true, if the message is a valid response to the command.
      def valid_response?(message)
      
        if message.kind_of?(IRC::Messages::PongMessage)
          return first_server == message.daemons[0] && second_server == message.daemons[1]
          
        elsif message.kind_of?(IRC::Messages::ErrorNoOriginMessage) || message.kind_of?(IRC::Messages::ErrorNoSuchServerMessage)
          return true
          
        end      
        
        return false
        
      end
      
    end      
  
  end
  
end  