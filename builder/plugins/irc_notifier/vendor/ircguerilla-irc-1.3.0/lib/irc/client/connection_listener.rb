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
# $Id: connection_listener.rb 90 2006-08-13 14:45:04Z roman $
# 
#require 'log4r'

module IRC
  
  module Client
    
    module ConnectionListener
      
      # This method gets called when successfully connected to an IRC server.
      def on_connect(connection, server)
      end
      
      # This method gets called an error message was received from the IRC server.
      def on_error(connection, reason)
      end
      
      # This method gets called when disconnected from a server.
      def on_disconnect(connection, server, reason = nil)
      end
      
      # This method gets called when a notice message was received.
      def on_notice(connection, user, message)
      end
      
      # This method gets called when a user (possibly us) joins a channel.
      def on_join(connection, channel, user)
      end
      
      # This message gets called when a channel join attempt failed.
      def on_join_failure(connection, channel, code, reason)
      end
      
      # This method gets called when a user gets kicked from a channel.
      def on_kick(connection, channel, kicker_user, kicked_user, reason)
      end
      
      # This method gets called when a user changes it's nick name.
      def on_nick(connection, before, after)
      end
      
      # This method gets called when the chosen nick name is already in use.
      def on_nick_already_in_use(connection, nick_name)
      end      
      
      # This method gets called when a user (possibly us) leaves a channel.
      def on_part(connection, channel, user)
      end
      
      # This method gets called when a channel part attempt failed.
      def on_part_failure(connection, channel)
      end
      
      # This method gets called when a ping message was received from the server.
      def on_ping(connection, servers)
      end
      
      # This method gets called when a pong message was received from the server.
      def on_pong(connection, daemons)
      end
      
      # This method gets called when a private message was received from a channel or an user.
      def on_private_message(connection, target, message)
      end
      
      # This method gets called when the connection was successfully registered.
      def on_registration(connection)
      end
      
      # This method gets called when an error happend during the connection registration.
      def on_registration_failure(connection, message)
      end
      
      # This method gets called when a message from the server was received.
      def on_server_response(connection, message)
      end
      
      # This method gets called when a welcome message was received.
      def on_welcome(connection, user, text)
      end

    end
    
  end
  
end