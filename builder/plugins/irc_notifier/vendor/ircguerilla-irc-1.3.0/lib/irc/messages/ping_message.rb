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
# $Id: ping_message.rb 93 2006-08-13 21:30:53Z roman $
# 
require 'irc/commands/pong_command'
require 'irc/messages/message'
require 'irc/messages/invalid_message'

module IRC
  
  module Messages
    
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
    class PingMessage < Message
    
      CODE = "PING"

      attr_reader :servers
      
      # Notify all connection listeners, that a ping message was received.
      def handle(context)
        
        # Notify all connection listeners by calling their on_server_response method.
        super(context)
        
        # Notify all connection listeners by calling their on_ping method.
        notify(context) do |connection_listener| 
          connection_listener.on_ping(context, servers)
        end

      end
      
      protected
      
      def parse(raw_message)

        # Initialize the base message fields.
        super(raw_message)      

        # Extract the message specific fields.
        match_data = Regexp.new(':?([^\s:]+)(\s+:?(.+))?').match(message)
        raise InvalidMessage.new("Can't parse ping message. Invalid message format.") if match_data == nil || code != CODE

        # Extract the servers and strip white spaces.
        @servers = [match_data[1], match_data[3]].compact.map! { |element| element.strip }
                
      end
      
    end      
    
  end
  
end  