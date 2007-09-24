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
# $Id: registered_state.rb 94 2006-08-13 21:40:40Z roman $
# 
require 'irc/client/client_error'
require 'irc/client/connected_state'
require 'irc/commands/join_command'
require 'irc/commands/nick_command'
require 'irc/commands/part_command'
#require 'log4r'

module IRC
  
  module Client
    
    class RegisteredState < ConnectedState
      
      def initialize
        #@log = Log4r::Logger.new('IRC::Client::RegisteredState')  
        @log = CruiseControl::Log
      end
      
      # Changes the nick name.
      def change_nick(context, nick)
        IRC::Commands::NickCommand.new(nick).execute(context)
      end              
      
      # Connects to the server. 
      def connect(context, server)
        raise ClientError.new("Can't connect to server. Already connected to a server.")
      end      
      
      # Joins the given channels.
      def join(context, channels)
        IRC::Commands::JoinCommand.new(channels).execute(context)
      end
      
      # Leaves the given channels.
      def part(context, channels)
        IRC::Commands::PartCommand.new(channels).execute(context)      
      end      
      
      # Register the connection by sending the password, nick and user commands.
      def register(context, nick, login, realname)
        raise ClientError.new("Can't register connection again. Already registered.")                  
      end
      
      # ConnectionListener
      
      # This method gets called when a user (possibly us) joins a channel.
      def on_join(context, channel, user)
        return unless context.nick.strip.downcase == user.nick.strip.downcase
        context.join_succeeded(channel) 
        @log.debug("#{network_name(context)} Successfully joined channel #{channel}.")
      end
      
      # This message gets called when a channel join attempt failed.
      def on_join_failure(context, channel, code, reason)
        @log.debug("#{network_name(context)} Failed to join channel #{channel}. #{reason.capitalize}.")
      end
      
      # This method gets called when a user gets kicked from a channel.
      def on_kick(context, channel, kick_user, kicked_user, reason)
      end
      
      # This method gets called when the chosen nick name is already in use.
      def on_nick_already_in_use(context, nick_name)
        return unless context.auto_nick_change
        raise ClientError("Maximum number of nick name changes reached. Giving up!") if context.nick_generator.names.empty?
        context.change_nick(context.nick_generator.pop) 
      end      
      
      # This method gets called when a user (possibly us) leaves a channel.
      def on_part(context, channel, user)
        return unless context.nick.strip.downcase == user.nick.strip.downcase
        context.part_succeeded(channel) 
        @log.debug("#{network_name(context)} Successfully left channel #{channel}.")        
      end
      
      # This method gets called when a channel part attempt failed.
      def on_part_failure(connection, channel)
      end
      
    end
    
  end
  
end
