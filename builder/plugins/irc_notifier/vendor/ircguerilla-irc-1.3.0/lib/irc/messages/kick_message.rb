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
# $Id$
# 
require 'irc/messages/message'
require 'irc/messages/invalid_message'

module IRC
  
  module Messages
    
   
    # 4.2.8 Kick command
    # 
    # Command: 	    KICK
    # Parameters: 	<channel> <user> [<comment>]
    # 
    # The KICK command can be used to forcibly remove a user from a channel. It 'kicks them out' 
    # of the channel (forced PART).
    # 
    # Only a channel operator may kick another user out of a channel. Each server that receives 
    # a KICK message checks that it is valid (ie the sender is actually a channel operator) 
    # before removing the victim from the channel.
    # 
    # Numeric Replies:
    # * ERR_NEEDMOREPARAMS 	
    # * ERR_NOSUCHCHANNEL
    # * ERR_BADCHANMASK 	
    # * ERR_CHANOPRIVSNEEDED
    # * ERR_NOTONCHANNEL 	
    # 
    # Examples:
    # 
    # KICK &Melbourne Matthew    ; Kick Matthew from &Melbourne
    # 
    # KICK #Finnish John :Speaking English
    #                            ; Kick John from #Finnish using
    #                            "Speaking English" as the reason
    #                            (comment).
    # 
    # :WiZ KICK #Finnish John    ; KICK message from WiZ to remove John
    #                            from channel #Finnish
    # 
    # NOTE:
    # 
    # It is possible to extend the KICK command parameters to the following:
    # 
    # <channel>{,<channel>} <user>{,<user>} [<comment>]   
    # 
    class KickMessage < Message
    
      CODE = "KICK"

      attr_reader :channel
      attr_reader :kicker
      attr_reader :kicked
      attr_reader :reason
      
      # Notify all connection listeners, that a user has joined a channel.
      def handle(context)
        
        # Notify all connection listeners by calling their on_server_response method.
        super(context)
        
        # Notify all connection listeners by calling their on_join method.
        notify(context) do |connection_listener| 
          connection_listener.on_kick(context, context.lookup_channel(channel), context.lookup_user(kicker), context.lookup_user(kicked), reason) 
        end
        
      end
      
      protected
      
      def parse(raw_message)

        # Initialize the base message fields.
        super(raw_message)      
        
        # Extract the message specific fields.
        match_data = Regexp.new('(\S+)\s+(\S+)(\s+:?(.+))?').match(message)
        raise InvalidMessage.new("Can't parse kick message. Invalid message format.") if match_data == nil || code != CODE
        
        # Extract the channel, kicker and the kciked user.
        @channel, @kicker, @kicked, @reason = match_data[1], nick, match_data[2], match_data[4]
        @server = nil
                
      end
      
    end      
    
  end
  
end  