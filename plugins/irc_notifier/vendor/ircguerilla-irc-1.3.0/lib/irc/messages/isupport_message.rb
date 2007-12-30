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
   
    class ISupportMessage < Message
    
      CODE = RPL_ISUPPORT

      attr_reader :options
      
      # Saves the supported options to the context.
      def handle(context)
        
        # Notify all connection listeners by calling their on_server_response method.
        super(context)
        
        options.each do |key, value|
          context.options[key] = value
        end
        
      end
      
      protected
      
      def parse(raw_message)

        # Initialize the base message fields.
        super(raw_message)  
        
        # Extract the message specific fields.
        match_data = Regexp.new('(\S+)\s+([^:]+)*\s+:?.*').match(message)
        raise InvalidMessage.new("Can't parse isupport message. Invalid message format.") if match_data == nil || code != CODE
        
        # Extract the nick name.
        @nick = match_data[1]
        
        # Extract the supported options.
        @options = Hash.new
        match_data[2].split(" ").each do |supported_option|
          
          key, value = supported_option.split("=")
          
          if value == nil
            @options[key] = true
          else            
            # TODO: value.to_i.to_s ?? Why does /\d+/ not work?
            @options[key] = (value.to_i.to_s == value ? value.to_i : value)
          end
                      
        end
                
      end
      
    end      
    
  end
  
end  