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
# $Id$
# 
require 'irc/commands/pong_command'
require 'irc/messages/message'
require 'irc/messages/invalid_message'

module IRC
  
  module Messages
   
    # 4.2.2 Part message
    # 
    # Command: 	    PART
    # Parameters: 	<channel>{,<channel>}
    # 
    # The PART message causes the client sending the message to be removed 
    # from the list of active users for all given channels listed in the 
    # parameter string.
    # 
    # Numeric Replies:
    # 
    # ERR_NEEDMOREPARAMS 	
    # ERR_NOSUCHCHANNEL
    # ERR_NOTONCHANNEL 	
    # 
    # Examples:
    # 
    # PART #twilight_zone    ; leave channel "#twilight_zone"
    # 
    # PART #oz-ops,&group5   ; leave both channels "&group5" and
    #                        ; "#oz-ops".
    # 
    class PartMessage < Message
    
      CODE = "PART"

      attr_reader :channel
      
      # Notify all connection listeners, that a user has left a channel.
      def handle(context)
      
        # Notify all connection listeners by calling their on_server_response method.
        super(context)
        
        # Notify all connection listeners by calling their on_part method.
        notify(context) do |connection_listener| 
          connection_listener.on_part(context, context.lookup_channel(channel), context.lookup_user(nick))
        end

      end
      
      protected
      
      def parse(raw_message)

        # Initialize the base message fields.
        super(raw_message)      

        # Extract the message specific fields.
        match_data = Regexp.new(':?(.+)').match(message)
        raise InvalidMessage.new("Can't parse part message. Invalid message format.") if match_data == nil || code != CODE
        
        # Extract the channel name.
        @channel = match_data[1]
                
      end
      
    end      
    
  end
  
end  