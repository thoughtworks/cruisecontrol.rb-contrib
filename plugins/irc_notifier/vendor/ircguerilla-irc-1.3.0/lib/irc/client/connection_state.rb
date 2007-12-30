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
# $Id: connection_state.rb 89 2006-08-13 14:03:35Z roman $
# 
require 'irc/client/connection_listener'
require 'singleton'

module IRC
  
  module Client
    
    class ConnectionState

      include ConnectionListener      
      include ::Singleton
      
      # Changes the nick name.
      def change_nick(context, nick)
      end               
      
      # Connects to the server. 
      def connect(context, server)
      end      
      
      # Disconnects from the currently connected server. 
      def disconnect(context, message = nil)
      end      
      
      # Joins the given channels.
      def join(context, channels)
      end
      
      # Leaves the given channels.
      def part(context, channels)
      end
      
      # Sends a private message to the target (a nick or a channel).
      def private_message(context, target, message)
      end
      
      # Register the connection by sending the password, nick and user commands.
      def register(context, nick, login, realname)
      end

      # Sends the command to the server bypassing the command queue.      
      def send_command(context, command)
        context.command_handler.send_command(command)      
      end
      
      # Sends the command to the server using the command queue.      
      def send_command_via_queue(context, command)
        context.command_handler.send_command_via_queue(command)            
      end
      
      # ConnectionListener
      
      # This method gets called when a ping message was received from the server.
      def on_ping(context, servers)
        IRC::Commands::PongCommand.new(servers[0], servers[1]).execute(context)
      end
      
      # This method gets called when a welcome message was received.
      def on_welcome(context, user, text)
        context.nick = user.nick
      end
      
      protected
      
      # This method changes the state of the connection context to the next state.
      def change_state(context, next_state)
        context.change_state(next_state)
      end
      
      def network_name(context)
        return "[#{context.network.to_s.upcase}]"
      end
      
    end
    
  end
  
end
