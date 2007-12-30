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
# $Id: message_handler.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/client/disconnected_state'
require 'irc/messages/factory'
#require 'log4r'
require 'timeout'

module IRC
  
  module Client
    
    class MessageHandlerError < Exception
    end
    
    class MessageHandler
      
      def initialize(context)
        #@log = Log4r::Logger.new('IRC::Client::MessageHandler')
        @log = CruiseControl::Log
        @context = context  
        @terminate = false
      end
      
      def start
        
        # Don't start the command handler if already started.
        raise MessageHandlerError.new("Can't start message handler. Already started.") if @thread != nil
        
        # Terminate the message reading loop if true.
        @terminate = false
        
        # Start the message handler thread.
        @thread = Thread.new do
          
          while @terminate == false do
  
            begin
  
              raw_message = nil
              
              # Read the raw message from the socket.              
              Timeout::timeout(0.5) do
                raw_message = socket.gets("\r\n")
              end                
              
              # Log the raw message.
              @log.debug("[#{@context.network.to_s.upcase}] <<< #{raw_message.chomp}")
                         
              # Create the message object & ask the message object to handle it.
              message = message = IRC::Messages::Factory.create(raw_message)   
              message.handle(@context)
              
            rescue IOError => e        
              @terminate = true
              @thread = nil
              
            rescue Timeout::Error => e
              # Ok
            end              

          end
          
        end
        
        @log.debug("[#{@context.network.to_s.upcase}] Message handler successfully started.")
        
      end
      
      def stop
        
        # Don't stop the command handler if already stopped.
        raise MessageHandlerError.new("Can't stop message handler. Already stopped.") if @thread == nil
        
        # Terminate the message reading loop.
        @terminate = true
        
        # Kill the thread.
#        Thread.kill(@thread)

        @thread = nil
        @log.debug("[#{@context.network.to_s.upcase}] Message handler successfully stopped.")
        
      end
      
      private
      
      def socket
        return @context.input_socket
      end
      
    end
    
  end
  
end