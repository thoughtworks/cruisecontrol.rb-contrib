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
# $Id: command_handler.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/commands/command'
require 'thread'
#require 'log4r'

module IRC
  
  module Client
    
    class CommandHandlerError < Exception
    end
    
    class CommandHandler
      
      DELAY_IN_MS = 1000 / 1000
      
      # The delay in milliseconds between two commands that are sent to the server.      
      attr_accessor :delay
      
      def initialize(context)
        #@log = Log4r::Logger.new('IRC::Client::CommandHandler')   
        @log = CruiseControl::Log   
        @context = context
        @queue = Queue.new
        @delay = DELAY_IN_MS
      end
      
      # Sends the command through a queue to the server. Sending commands
      # through a queue prevents from flooding the IRC server.
      def <<(command)
        send_command_via_queue(command)
      end
      
      # Sends the command directly to the server bypassing the queue. Sending commands too fast 
      # to the server can result in a disconnect from the server.
      def send_command(command)
        @context.output_socket << "#{command.to_s}\r\n"
        @log.debug("[#{@context.network.to_s.upcase}] >>> #{command.to_s}")
      end
      
      # Sends the command through a queue to the server. Sending commands through a queue prevents 
      # from flooding the IRC server.
      def send_command_via_queue(command)
        @queue << command
      end
      
      def start
        
        # Don't start the command handler if already started.
        raise CommandHandlerError.new("Can't start command handler. Already started.") if @thread != nil
        
        # Start the command handler thread.        
        @thread = Thread.new do

          loop do
            
            # Get the next command from the command queue.

            command = @queue.pop

            # Send the command to the server.
            send_command(command)
            
            # Wait some milliseconds to prevent server flodding.
            sleep(delay)
            
          end  
                  
        end
        
        @log.debug("[#{@context.network.to_s.upcase}] Command handler successfully started.")
        
      end
      
      def stop
        
        # Don't stop the command handler if already stopped.
        raise CommandHandlerError.new("Can't stop command handler. Already stopped.") if @thread == nil
        
        # Kill the thread & clear the command queue.
        Thread.kill(@thread)
        @queue.clear
        
        @log.debug("[#{@context.network.to_s.upcase}] Command handler successfully stopped.")
        
      end
      
    end
    
  end
  
end