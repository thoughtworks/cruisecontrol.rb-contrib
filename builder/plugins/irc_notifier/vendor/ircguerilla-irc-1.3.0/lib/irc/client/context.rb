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
# $Id: context.rb 92 2006-08-13 17:54:26Z roman $
# 
require 'delegate'
require 'irc/client/command_handler'
require 'irc/client/context'
require 'irc/client/connection_listener'
require 'irc/client/disconnected_state'
require 'irc/client/message_handler'
require 'irc/util/nick_generator'
#require 'log4r'

module IRC
  
  module Client
    
    class Connection
      
      class Context < DelegateClass(IRC::Client::ConnectionListener)
      
        # READER      
        
        # The command handler that is responsible for sending commands to the IRC server.        
        attr_reader :command_handler
        
        # The connection listeners that get notified when a message was received by the IRC server.
        attr_reader :connection_listeners
        
        # The nick name generator that used, when automatic nick name change is enabled.
        attr_reader :nick_generator
        
        # The context's current state. The initial state is disconnected.
        attr_reader :state

        # ACCESSOR       

        # When set to true the connection object changes the nick name automatically when 
        # the chosen name is already in use.
        attr_accessor :auto_nick_change

        # The login name that is used when connected to an IRC server.
        attr_accessor :login

        # The network to which the context is connected., or nil if no connection has been established.        
        attr_accessor :network

        # The nick name that is used when connected to an IRC server.
        attr_accessor :nick

        # The real name that is used when connected to an IRC server.
        attr_accessor :realname

        # The options that are supported by the server.
        attr_accessor :options

        # The IRC server the context is connected to, or nil if no connection has been established. 
        attr_accessor :server        

        # The TCPSocket the context uses to talk to the IRC server.
        attr_writer :input_socket
        attr_writer :output_socket        
        
        def initialize(nick = nil, login = nil, realname = nil)
          
          # Initialize logging framework.
          #@log = Log4r::Logger.new('IRC::Client::Connection::Context')  
          @log = CruiseControl::Log
          # Initialize nick, login & realname. If a value is missing it
          # is taken from the environemnt settings.
          @nick = nick || ENV['USER'] || ENV['USERNAME'] || "i-AM-TOO-LAME"
          @login = login || ENV['USER'] || ENV['USERNAME'] || nick
          @realname = realname || ENV['USER'] || ENV['USERNAME'] || nick
          
          # Enable automatic nick change. Use the nick name generator.
          @auto_nick_change = true
          @nick_generator = IRC::Util::NickGenerator.new(@nick)
          
          # A hash to keep track of currently joined channels.
          @joined_channels = Hash.new
          
          # All connection listeners will get notified when a message was received from the IRC server.
          @connection_listeners = Array.new

          # Add the context as a connection listener. The context doesn't handle messages from the server 
          # directly. Instead method calls to the ConnectionListner module get forwarded to the current
          # state object. When the context changes it's state the delegation object is allso changed to 
          # the new state.
          add_connection_listener(self)
          
          # Change into the disconnected state.
          change_state(DisconnectedState.instance)
          
          # The options from the isupport messages.
          @options = Hash.new
          
        end
        
        # Adds a new connection listener. The connection listener gets notified when a 
        # message was received from the IRC server.
        def add_connection_listener(connection_listener)
          connection_listeners << connection_listener unless connection_listeners.include?(connection_listener)
        end
        
        # Sends the command to the server using the command queue.
        def <<(command)
          send_command_via_queue(command)
        end
        
        # Changes the context's state to the next state,
        def change_nick(new_nick)
          state.change_nick(self, new_nick)
        end        
        
        # Changes the context's state to the next state,
        def change_state(next_state)

          # Log the state change.
          if state == nil
            @log.debug("Setting initial state to #{next_state.class.name}.")    
          else
            @log.debug("Changing state from #{state.class.name} to #{next_state.class.name}.")
          end

          # Change the context's state.
          @state = next_state          
          
          # The context doesn't handle messages from the server directly. Method calls to the 
          # ConnectionListener module get forwarded to the current state object.
          __setobj__(@state)
          
        end
        
        # Connects to the server. 
        def connect(server)
          @network = server.network
          state.connect(self, server)
        end
        
        # Returns true if a connection to an IRC server has been established.
        def connected?
          state.kind_of?(ConnectedState)  
        end
        
        # Disconnects from the currently connected server. 
        def disconnect(message = nil)
          state.disconnect(self, message)        
        end

        # Returns the socket, that is used to receive messages from the server.   
        def input_socket
          return @input_socket
        end
        
        # Returns the socket, that is used to send commands to the server.   
        def output_socket
          return @output_socket
        end
        
         # Joins the given channels.
        def join(channels)
          state.join(self, channels)
        end
        
        # Returns true, if the given channel is currently joined.
        def joined?(channel)
          return @joined_channels.include?(channel)
        end

        # Add the channel to the list of joined channels.
        def join_succeeded(channel)
          @joined_channels[channel.name] = channel
        end

        # Remove the channel from the list of joined channels.
        def part_succeeded(channel)
          @joined_channels.delete(channel)
        end

        # Returns an Array of all currently joined channels.        
        def joined_channels
          return @joined_channels.values
        end
        
        # Lookup or create a channel object.
        def lookup_channel(channel)
          return network.lookup_or_create_channel(channel)
        end

        # Lookup or create a server object.
        def lookup_server(server)
          return network.lookup_or_create_server(server)
        end
        
        # Lookup or create a user object.
        def lookup_user(user)
          return network.lookup_or_create_user(user)
        end

        # The network to which the context is connected, or nil if no connection has been established.        
        def network
          return @network
        end
        
        # Leaves the given channels.
        def part(channels)
          state.part(self, channels)
        end    
        
        # Register the connection by sending the password, nick and user commands.
        def register(nick = nil, login = nil, realname = nil)
          state.register(self, nick || self.nick, login || self.login, realname || self.realname)
        end        
        
        # Returns true if a connection to an IRC server has been established and the connection
        # has been successfully registered.
        def registered?
          state.kind_of?(RegisteredState)  
        end
        
        # Removes a previously added connection listener. The connection listener will not
        # get notified any longer when a message was received from the IRC server.
        def remove_connection_listener(connection_listener)
          connection_listeners.delete(connection_listener)
        end
        
        # Sends the command to the server bypassing the command queue.      
        def send_command(command)
          state.send_command(self, command)          
        end

        # Sends the command to the server using the command queue.      
        def send_command_via_queue(command)
          state.send_command_via_queue(self, command)  
        end

        # Initializes and starts the command handler.        
        def start_command_handler        
          @command_handler = CommandHandler.new(self)
          @command_handler.start
        end
        
        # Initializes and starts the message handler.        
        def start_message_handler        
          @message_handler = MessageHandler.new(self)
          @message_handler.start
        end

        # Stops the command handler.
        def stop_command_handler        
          @command_handler.stop
          @command_handler = nil
        end
        
        # Stops the message handler.        
        def stop_message_handler        
          @message_handler.stop
          @message_handler = nil
        end
        
      end 
      
    end
    
  end
  
end