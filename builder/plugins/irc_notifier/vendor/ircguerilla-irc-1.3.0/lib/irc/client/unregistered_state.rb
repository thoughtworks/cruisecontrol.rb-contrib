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
# $Id: unregistered_state.rb 90 2006-08-13 14:45:04Z roman $
# 
require 'irc/client/client_error'
require 'irc/client/connected_state'
require 'irc/client/registered_state'
require 'irc/messages/error_message'
require 'irc/commands/nick_command'
require 'irc/messages/notice_message'
require 'irc/commands/password_command'
require 'irc/messages/ping_message'
require 'irc/commands/user_command'
#require 'log4r'

module IRC
  
  module Client
    
    class UnregisteredState < ConnectedState
      
      def initialize
        #@log = Log4r::Logger.new('IRC::Client::UnregisteredState')  
        @log = CruiseControl::Log
      end
      
      # Changes the nick name.
      def change_nick(context, nick)
        raise ClientError.new("Can't change nick name. The connection is not yet registered.")
      end               
      
      # Joins the given channels.
      def join(context, channels)
        raise ClientError.new("Can't join any channel. The connection is not yet registered.")
      end
      
      # Leaves the given channels.
      def part(context, channels)
        raise ClientError.new("Can't leave any channel. The connection is not yet registered.")
      end
      
      # Sends a private message to the target (a nick or a channel).
      def private_message(context, target, message)
        raise ClientError.new("Can't send  a private message. The connection is not yet registered.")
      end
      
      # Register the connection by sending the password, nick and user commands.
      def register(context, nick, login, realname)

        if context.server.password
          IRC::Commands::PasswordCommand.new(context.server.password).execute(context)
        end          
        
        IRC::Commands::NickCommand.new(nick).execute(context)
        IRC::Commands::UserCommand.new(nick, Socket.gethostname, context.server.hostname, realname).execute(context)
        
        context.nick, context.login, context.realname = nick, login, realname

      end            
     
      # ConnectionListener  
      
      # This method gets called when a message from the server is received.
      def on_server_response(context, message)
            
        case message.code
        
          # Ignore notice messages.
          when IRC::Messages::NoticeMessage::CODE
            return
            
          # Ignore ping messages.
          when IRC::Messages::PingMessage::CODE
            return
                  
          # The given nick name is not valid.  
          when IRC::Messages::ErrorErroneusNickNameMessage::CODE
            registration_failure(context, message)   
            return            
                    
          # We didn't send a valid command. There are some parameters missing.       
          when IRC::Messages::ErrorNeedMoreParametersMessage::CODE
            registration_failure(context, message)     
            return
                        
          # Nick name collision.  
          when IRC::Messages::ErrorNickCollisionMessage::CODE
            registration_failure(context, message)                        
            return
                        
          # The chosen nick name is already in use.  
          when IRC::Messages::ErrorNickNameInUseMessage::CODE
            registration_failure(context, message)            
            return
                        
          # We didn't send a valid nick command. The nick name was missing.
          when IRC::Messages::ErrorNoNickNameGivenMessage::CODE
            registration_failure(context, message)       
            return
        
        end          
        
          # Everything ok. Change to the registered state.            
          change_state(context, RegisteredState.instance)
            
          # Notify all connection listeners that we are successfully connected now.
          context.connection_listeners.each do |connection_listener|
            connection_listener.on_registration(context)
          end  
      
      end     
      
      protected

      # Notify all connection listeners that an error occured during the connection registration.      
      def registration_failure(context, message)       
      
        context.connection_listeners.each do |connection_listener|
          connection_listener.on_registration_failure(context, message)
        end
        
        return unless context.auto_nick_change
        
        raise ClientError("Maximum number of nick name changes reached. Giving up!") if context.nick_generator.names.empty?
        nick = context.nick_generator.pop
        
        IRC::Commands::NickCommand.new(nick).execute(context)
        IRC::Commands::UserCommand.new(nick, Socket.gethostname, context.server.hostname, context.realname).execute(context)
      
      end
      
    end
    
  end
  
end
