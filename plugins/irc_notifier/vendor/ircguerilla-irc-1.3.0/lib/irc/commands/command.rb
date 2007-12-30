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
# $Id: command.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/client/connection_listener'
require 'irc/commands/invalid_command'
require 'monitor'

module IRC
  
  module Commands
    
    class Command < Monitor
      
      include IRC::Client::ConnectionListener

      # The message that was sent by the IRC server as a response to the execution of the command.      
      attr_reader :response
    
      def initialize(raw_command = "")
        super()
        @raw_command = raw_command
      end
    
      # Returns the command as a string.
      def command
        return @raw_command
      end
      
      # Execute the command. The method registers the command as an connection listener
      # at the connection object and sends the command. The method returns the command.
      def execute(connection)
      
        # Register the command as a connection listener, so we can receive response messages
        # from the server.
        connection.add_connection_listener(self)
        
        # Send the message.
        connection << self
        
        # Create a conditinal monitor variable.
        self.synchronize do
          @response_received ||= self.new_cond
        end
        
        return self
        
      end
      
      # Returns the command as a string.
      def to_s
        return command
      end
      
      # Returns true, if the message is a valid response to the command. This method should get 
      # overriddn in subclasses. For this class every response is valid.
      def valid_response?(message)
        return true
      end
      
      # Waits until a response for the command was sent by the IRC server. This method expects, 
      # that the command has already been sent to the server by the execute method. A call to 
      # this method blocks until a response was reseived from the server.
      def wait
      
        # If the command has not been sent, or a response was already received. a
        # call to this method doesn't make any sense.
        raise Exception.new("Can't wait for response. The command was not send yet, or a response was already received.") if @response_received == nil
        
        # Wait until a response was received from the server.
        synchronize do
          @response_received.wait_until { response != nil }
        end
        
      end
      
      # CONNECTION LISTENER
      
      # This method gets called when a message from the server is received. This method should be 
      # overridden in subclasses to handle the command specific response messages from the server.
      def on_server_response(connection, message)
        
        if valid_response?(message)
          connection.remove_connection_listener(self)
          @response = message
        end
        
      end
  
    end
    
  end
  
end  