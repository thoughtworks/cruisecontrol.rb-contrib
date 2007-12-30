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
# $Id: connected_state.rb 88 2006-08-13 12:42:58Z roman $
# 
require 'irc/client/client_error'
require 'irc/client/connection_state'
require 'irc/client/disconnected_state'
require 'irc/commands/nick_command'
require 'irc/commands/password_command'
require 'irc/commands/user_command'
require 'irc/commands/pong_command'
require 'irc/commands/quit_command'
#require 'log4r'

module IRC
  
  module Client
    
    class ConnectedState < ConnectionState
      
      def initialize
        #@log = Log4r::Logger.new('IRC::Client::ConnectedState')  
        @log = CruiseControl::Log
      end
      
      # Changes the nick name.
      def change_nick(context, nick)
      end               
      
      # Connects to the server. 
      def connect(context, server)
        raise ClientError.new("Can't connect to server. Already connected to a server.")
      end    
      
      # Disconnects from the currently connected server. 
      def disconnect(context, message = nil)
      
        @log.debug("#{network_name(context)} Disconnecting from server #{context.server.hostname}.")
      
        # Send the quit command. If no quit message is given, the nick name will be
        # send as the default quit message.
        send_command(context, IRC::Commands::QuitCommand.new(message || context.nick))
        
        # Stop the command & message handlers.
        context.stop_command_handler
        context.stop_message_handler
        
        # Set network & server to nil.
        context.network = context.server = nil
        
        # Close input/output socket and set them to nil.
        context.input_socket.close if context.input_socket != nil && !context.input_socket.closed?
        context.input_socket = nil

        context.output_socket.close if context.output_socket != nil && !context.output_socket.closed?
        context.output_socket = nil

        # Change to the disconnected state.
        change_state(context, DisconnectedState.instance)
        
      end 
      
      # Register the connection by sending the password, nick and user commands.
      def register(context, nick, login, realname)
        raise ClientError.new("Can't register connection. Connection registration is only possible in the unregistered state.")
      end            
      
      # ConnectionListener

      def on_error(context, reason)
      
        @log.debug("#{network_name(context)} Got disconnected from server #{context.server.hostname}. #{reason.capitalize}.")
        
        # Stop the command & message handlers.
        context.stop_command_handler
        context.stop_message_handler
                
        # Set network & server to nil.
        context.network = context.server = nil
        
        # Close input/output socket and set them to nil.
        context.input_socket.close if context.input_socket != nil && !context.input_socket.closed?
        context.input_socket = nil

        context.output_socket.close if context.output_socket != nil && !context.output_socket.closed?
        context.output_socket = nil

        # Change to the disconnected state.
        change_state(context, DisconnectedState.instance)
              
      end
                  
      # This method gets called when disconnected from a server.
      def on_disconnect(context, server, reason = nil)
        log.debug("#{network_name(context)} Successfully disconnected from #{server}. #{reason != nil ? reason + '.' : ''}")      
      end
      
      # This method gets called when a user changes it's nick name.
      def on_nick(context, before, after)
        return if before.nick.strip.downcase != context.nick.strip.downcase
        context.nick = after.nick
        @log.debug("#{network_name(context)} Successfully changed nick name from #{before.nick} to #{after.nick}.")              
      end      
      
      # This method gets called when a ping message was received from the server.
      def on_ping(context, servers)
        IRC::Commands::PongCommand.new(servers[0], servers[1]).execute(context)
      end      
      
      
    end
    
  end
  
end
