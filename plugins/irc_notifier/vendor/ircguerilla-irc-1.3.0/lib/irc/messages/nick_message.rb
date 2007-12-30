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
# $Id: nick_message.rb 89 2006-08-13 14:03:35Z roman $
# 
require 'irc/messages/message'
require 'irc/messages/invalid_message'

module IRC
  
  module Messages
    
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
    class NickMessage < Message
    
      CODE = "NICK"

      attr_reader :after            
      attr_reader :before
      
      # Notify all connection listeners, that a user changed it's nick name.
      def handle(context)
        
        # Notify all connection listeners by calling their on_server_response method.
        super(context)
        
        # Notify all connection listeners by calling their on_nick method.
        notify(context) do |connection_listener| 
          connection_listener.on_nick(context, context.lookup_user(before), context.lookup_user(after))
        end

      end
      
      protected      
      
      def parse(raw_message)

        # Initialize the base message fields.
        super(raw_message)      

        # Match the message against the message format.
        match_data = Regexp.new('\s*:?(\S+)\s+NICK\s+:?(\S+)\s*').match(raw_message)
        raise InvalidMessage.new("Can't parse nick message. Invalid message format.") unless match_data

        # Initialize the variables holding the nick names before & after the nick change.        
        @after = match_data[2]
        @before = nick #match_data[1]        
        
      end
      
    end      
    
  end
  
end  