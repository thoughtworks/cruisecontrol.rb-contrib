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
# $Id: connection.rb 85 2006-08-13 11:42:07Z roman $
# 

require 'irc/client/context'

module IRC
  
  module Client
    
    class Connection
      
      MAX_CONNECTION_TIMEOUT_IN_SEC = 5
      
      def initialize(nick = nil, login = nil, realname = nil)
        @context = IRC::Client::Connection::Context.new(nick, login, realname)
      end
      
      # Adds a new connection listener. The connection listener gets notified when a 
      # message was received from the IRC server.
      def add_connection_listener(connection_listener)
        @context.add_connection_listener(connection_listener)
      end
      
      # Sends the command to the server using the command queue.
      def <<(command)
        @context<<(command)
      end    
      
      # Connects to the server. 
      def connect(server)
        @context.connect(server)
      end
      
      # Returns true if a connection to an IRC server has been established.
      def connected?
        @context.connected?
      end
      
      # Returns all registered connection listeners.
      def connection_listeners
        return @context.connection_listeners
      end
      
      # Disconnects from the currently connected server. 
      def disconnect(message = nil)
        @context.disconnect(message)
      end
      
      # Joins the given channels.
      def join(channels)
        @context.join(channels)
      end
      
      # Returns true, if the given channel is currently joined.
      def joined?(channel)
        @context.joined?(channel)
      end
      
      # Returns an Array of all currently joined channels.        
      def joined_channels
        @context.joined_channels
      end
      
      # The network to which the context is connected, or nil if no connection has been established.        
      def network
        @context.network
      end
      
      # Returns the nick name that is used when connected to an IRC server.
      def nick
        @context.nick
      end
      
      # Returns the nick name that is used when connected to an IRC server.
      def nick=(new_nick)
        @context.change_nick(new_nick)
      end

      # Returns the supported options of the currently connected server.
      def options
        return @context.options
      end
      
      # Leaves the given channels.
      def part(channels)
        @context.part(channels)
      end       

      # Returns the real name that is used when connected to an IRC server.
      def realname
        @context.realname
      end
      
      # Register the connection by sending the password, nick and user commands.
      def register(nick = nil, login = nil, realname = nil)
        @context.register(nick, login, realname)
      end        

      # Returns true if a connection to an IRC server has been established and the connection
      # has been successfully registered.
      def registered?
        @context.registered?
      end
      
      # Removes a previously added connection listener. The connection listener will not
      # get notified any longer when a message was received from the IRC server.
      def remove_connection_listener(connection_listener)
        @context.remove_connection_listener(connection_listener)
      end
      
      # Sends the command to the server bypassing the command queue.      
      def send_command(command)
        @context.send_command(command)
      end
      
      # Sends the command to the server using the command queue.      
      def send_command_via_queue(command)
        @context.send_command_via_queue(command)
      end
      
      # Returns the server, to which the connection object is connected to.      
      def server
        return @context.server
      end
      
      
    end
    
  end
  
end