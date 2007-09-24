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
# $Id: message.rb 93 2006-08-13 21:30:53Z roman $
# 
require 'pp'
require 'irc/messages/codes'
require 'irc/messages/invalid_message'

module IRC
  
  module Messages
    
    class Message
    
      include Codes
    
      MESSAGE_FORMAT = Regexp.new('(:([^!\s]+)(!([^@\s]+))?(@(\S+))?\s+)?(\w+|\d\d\d)\s*(.*)')      

      attr_reader :code
      attr_reader :host
      attr_reader :message      
      attr_reader :nick
      attr_reader :raw_message      
      attr_reader :server
      attr_reader :login      
      
      def initialize(raw_message)
        parse(raw_message)
      end
      
      def ==(other)
        return eql?(other)
      end        
      
      # Returns true if the other Message object is equal to the current.
      def eql?(other)
        return false if !other.kind_of?(Message)
        return false if code != other.code
        return false if host != other.host        
        return false if message != other.message        
        return false if raw_message != other.raw_message
        return false if server != other.server        
        return false if login != other.login        
        return true
      end          
      
      # Notify all connection listeners that a message was received from the IRC server, 
      # by calling their on_server_response method.
      def handle(context)

        # Notify all connection listeners by calling their on_server_response method.
        notify(context) do |connection_listener|
          connection_listener.on_server_response(context, self)
        end
        
      end
      
      # Returns true if the given string matches the IRC message format, else false.
      def self.is_valid?(raw_message)
        return Regexp.new(MESSAGE_FORMAT).match(raw_message) != nil
      end
      
      def to_s
        return raw_message
      end
      
      protected

      # Notify all connection listeners, by calling the surrounding block with a channel listener as parameter.
      def notify(context)
      
        context.connection_listeners.each do |connection_listener|
          yield connection_listener
        end
      
      end
      
      def parse(raw_message)        
      
        # Throw an exception if the given message doesn't match the IRC message format.      
        raise InvalidMessage.new("Can't create message. Invalid IRC message format.") unless Message.is_valid?(raw_message)
        
        # Save the raw message for later use.
        @raw_message = raw_message
        
        # Parse the raw message & initialize the IRC message fields.
        match_data = MESSAGE_FORMAT.match(raw_message)
        
        # Extract nick & server. 
        @nick = match_data[2]        
        @server = match_data[4] != nil || match_data[6] != nil ? nil : match_data[2]                
        
        # Extract the login & host name.
        @login = match_data[4]
        @host = match_data[6]        

        # Extract the IRC message code. If the code is a number, convert it to an integer.
        @code = (match_data[7].match(/\d+/) ? match_data[7].to_i : match_data[7])
  
#        puts @code
#        puts @code.class
      
        # Extract the rest of the message. The message is everything after the IRC message code.
        @message = match_data[8]
      
      end
    
    end
    
  end
  
end