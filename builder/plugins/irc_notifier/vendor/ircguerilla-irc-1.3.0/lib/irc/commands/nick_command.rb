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
# $Id: nick_command.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/commands/command'
require 'irc/commands/invalid_command'
require 'irc/messages/notice_message'

module IRC
  
  module Commands
    
    # 4.1.2 Nick message
    # 
    # Command: 	NICK
    # Parameters: 	<nickname> [ <hopcount> ]
    # 
    # NICK message is used to give user a nickname or change the previous one. The 
    # <hopcount> parameter is only used by servers to indicate how far away a nick 
    # is from its home server. A local connection has a hopcount of 0. If supplied 
    # by a client, it must be ignored.
    # 
    # If a NICK message arrives at a server which already knows about an identical 
    # nickname for another client, a nickname collision occurs. As a result of a 
    # nickname collision, all instances of the nickname are removed from the server's 
    # database, and a KILL command is issued to remove the nickname from all other 
    # server's database. If the NICK message causing the collision was a nickname 
    # change, then the original (old) nick must be removed as well.
    # 
    # If the server recieves an identical NICK from a client which is directly 
    # connected, it may issue an ERR_NICKCOLLISION to the local client, drop the NICK 
    # command, and not generate any kills.
    # 
    # Numeric Replies:
    # 
    # ERR_NONICKNAMEGIVEN 	
    # ERR_ERRONEUSNICKNAME
    # ERR_NICKNAMEINUSE 	
    # ERR_NICKCOLLISION
    # 
    # Example:
    # 
    # NICK Wiz                 ; Introducing new nick "Wiz".
    # 
    # :WiZ NICK Kilroy         ; WiZ changed his nickname to Kilroy.
    #     
    class NickCommand < Command
      
      attr_reader :nick
      attr_reader :hopcount      
      
      def initialize(nick, hopcount = nil)
        raise InvalidCommand.new("Can't create nick command. No nick name.") unless nick
        @nick = nick
        @hopcount = hopcount
        super(command)              
      end
      
      def command
        return "NICK #{nick} #{hopcount ? hopcount.to_s : ''}"
      end
      
      # This method gets called when a message from the server is received. 
      def on_server_response(connection, message)

        # Ignore notice messages      
        return if message.code == IRC::Messages::NoticeMessage::CODE
        
        if !connection.registered? || (connection.registered? && message.code == IRC::Messages::NickMessage::CODE)
          connection.remove_connection_listener(self)
          @response = message
        end
        
      end      
      
    end      
  
  end
  
end  