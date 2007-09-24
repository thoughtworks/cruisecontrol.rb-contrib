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
require 'irc/messages/error_join_message'
require 'irc/messages/invalid_message'
require 'irc/messages/message'

module IRC
  
  module Messages
    
    class ErrorJoinMessage < Message
    
      attr_reader :channel
      attr_reader :reason
          
      # Notify all connection listeners, that the channel join failed.
      def handle(context)
        
         # Notify all connection listeners by calling their on_server_response method.
        super(context)
        
        # Notify all connection listeners by calling their on_join_failure method.
        notify(context) do |connection_listener| 
          connection_listener.on_join_failure(context, context.lookup_channel(channel), code, reason)
        end

      end
      
      protected
      
      def parse(raw_message)

        # Initialize the base message fields.
        super(raw_message)      
        
        match_data = Regexp.new('(\S+)\s+(\S+)\s+:?(.+)').match(message)
        raise InvalidMessage.new("Can't parse 'nick already in use' message. Invalid message format.") unless match_data
        
        # Extract nick & channel name and the error reason.
        @nick, @channel, @reason = match_data[1], match_data[2], match_data[3]
                
      end    
    
      
    end      
  
  end
  
end  