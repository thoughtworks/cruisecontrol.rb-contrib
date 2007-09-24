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
# $Id: disconnected_state.rb 89 2006-08-13 14:03:35Z roman $
# 
require 'irc/client/client_error'
require 'irc/client/connection'
require 'irc/client/connection_state'
require 'irc/client/unregistered_state'
require 'irc/models/server'
#require 'log4r'
require 'socket'
require 'timeout'


module IRC
  
  module Client
    
    class DisconnectedState < ConnectionState
      
      def initialize
        #@log = Log4r::Logger.new('IRC::Client::DisconnectedState')  
        @log = CruiseControl::Log
      end
      
      # Changes the nick name.
      def change_nick(context, nick)
        raise ClientError.new("Can't change nick name. Not connected to a server.")
      end               
      
      # Connects to the server. 
      def connect(context, server)
        
        @log.debug("#{network_name(context)} Trying to connect to server #{server.hostname} on port #{server.port}.")
        
        # Establish the connection to the server.        
        establish_connection(context, server)
        
        # Set the server to which we are connected.    
        context.server = server
        
        # Clear the supported options, that get initialized by the isupport messages.
        context.options = Hash.new
        
        # Initialize and start the command & message handlers.
        context.start_command_handler
        context.start_message_handler      
        
        # Change to the unregistered state.
        change_state(context, UnregisteredState.instance)                  
        
        # Notify all connection listeners that we are successfully connected now.
        context.connection_listeners.each do |connection_listener|
          connection_listener.on_connect(context, server)
        end  
        
      rescue Exception => e
        raise ClientError.new("Can't connect to server #{server.hostname} on port #{server.port}. #{e.message.capitalize}.")
        
      end      
      
      # Disconnects from the currently connected server. 
      def disconnect(context, message = nil)
        raise ClientError.new("Can't disconnect. Not connected to a server.")
      end      
      
      # Joins the given channels.
      def join(context, channels)
        raise ClientError.new("Can't join any channel. Not connected to a server.")      
      end
      
      # Leaves the given channels.
      def part(context, channels)
        raise ClientError.new("Can't leave any channel. Not connected to a server.")      
      end
      
      # Sends a private message to the target (a nick or a channel).
      def private_message(context, target, message)
        raise ClientError.new("Can't send a private message. Not connected to a server.")            
      end
      
      # Register the connection by sending the password, nick and user commands.
      def register(context, nick, login, realname)
        raise ClientError.new("Can't register connection. Not connected to a server.")                  
      end
      
      # Sends the command to the server bypassing the command queue.      
      def send_command(context, command)
        raise ClientError.new("Can't send command. Not connected to a server.")
      end
      
      # Sends the command to the server using the command queue.      
      def send_command_via_queue(context, command)
        raise ClientError.new("Can't send command. Not connected to a server.")
      end        
      
      # ConnectionListener
      
      # This method gets called when successfully connected to a server.
      def on_connect(connection, server)
        log.debug("#{network_name(connection)} Successfully connected to #{server} on port #{server.respond_to?(port) ? server.port.to_s : IRC::Models::Server::DEFAULT_PORT}.")
      end
      
      private
      
      def establish_connection(context, server)
      
        # Try to connect to the server before the timeout exceeds.
        Timeout::timeout(Connection::MAX_CONNECTION_TIMEOUT_IN_SEC) do
          
          socket = TCPSocket.open(server.hostname, server.port)
          
          context.input_socket = socket
          context.output_socket = socket          
          
        end 
      
      end
      
    end
    
  end
  
end
