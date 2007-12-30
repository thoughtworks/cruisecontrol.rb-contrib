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
# $Id: pong_message.rb 93 2006-08-13 21:30:53Z roman $
# 
require 'irc/messages/message'
require 'irc/messages/invalid_message'

module IRC
  
  module Messages
    
    # 4.6.3 Pong message
    # 
    # Command: 	PONG
    # Parameters: 	<daemon> [<daemon2>]
    # 
    # PONG message is a reply to ping message. If parameter <daemon2> is given this message must 
    # be forwarded to given daemon. The <daemon> parameter is the name of the daemon who has responded 
    # to PING message and generated this message.
    # 
    # Numeric Replies:
    # * ERR_NOORIGIN 
    # *	ERR_NOSUCHSERVER
    # 
    # Examples:
    # 
    # PONG csd.bu.edu tolsun.oulu.fi  ; PONG message from csd.bu.edu to
    # 
    class PongMessage < Message
    
      CODE = "PONG"

      attr_reader :daemons
      
      # Notify all message listeners, that a pong message was received.
      def handle(context)

        # Notify all connection listeners by calling their on_server_response method.
        super(context)
        
        # Notify all connection listeners by calling their on_pong method.
        notify(context) do |connection_listener| 
          connection_listener.on_pong(context, daemons)
        end

      end
      
      protected
      
      def parse(raw_message)

        # Initialize the base message fields.
        super(raw_message)      

        # Extract the message specific fields.
        match_data = Regexp.new(':?([^\s:]+)(\s+:?(.+))?').match(message)
        raise InvalidMessage.new("Can't parse pong message. Invalid message format.") if match_data == nil || code != CODE

        # Extract the servers and strip white spaces.
        @daemons = [match_data[1], match_data[3]].compact.map! { |element| element.strip }
                
      end
      
    end      
    
  end
  
end  