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
require 'irc/messages/message'
require 'irc/messages/invalid_message'

module IRC
  
  module Messages
    
    class WelcomeMessage < Message
    
      CODE = RPL_WELCOME

      attr_reader :text
      
      # Notify all connection listeners, that a private message was received.
      def handle(context)
        
        # Notify all connection listeners by calling their on_server_response method.
        super(context)
        
        # Notify all connection listeners by calling their on_private_message method.
        notify(context) do |connection_listener| 
          connection_listener.on_welcome(context, context.lookup_user(nick), text)
        end

      end
      
      protected      
      
      def parse(raw_message)

        # Initialize the base message fields.
        super(raw_message)      

        # Extract the message specific fields.
        match_data = Regexp.new('(\S+)\s+:?(.+)').match(message)
        raise InvalidMessage.new("Can't parse private message. Invalid message format.") if match_data == nil || code != CODE

        # Extract the sender, target and the text.
        @nick, @text = match_data[1], match_data[2]
        
      end
      
    end      
    
  end
  
end  