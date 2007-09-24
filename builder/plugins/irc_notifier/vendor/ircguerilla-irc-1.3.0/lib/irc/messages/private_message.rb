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
require 'irc/models/channel'

module IRC
  
  module Messages
    
    # 4.4.1 Private messages
    # 
    # Command: 	    PRIVMSG
    # Parameters: 	<receiver>{,<receiver>} <text to be sent>
    # 
    # PRIVMSG is used to send private messages between users. <receiver> is the nickname 
    # of the receiver of the message. <receiver> can also be a list of names or channels 
    # separated with commas.
    # 
    # The <receiver> parameter may also me a host mask (#mask) or server mask ($mask). In 
    # both cases the server will only send the PRIVMSG to those who have a server or host 
    # matching the mask. The mask must have at least 1 (one) "." in it and no wildcards 
    # following the last ".". This requirement exists to prevent people sending messages 
    # to "#*" or "$*", which would broadcast to all users; from experience, this is abused 
    # more than used responsibly and properly. Wildcards are the '*' and '?' characters. 
    # This extension to the PRIVMSG command is only available to Operators.
    # 
    # Numeric Replies:
    # * ERR_NORECIPIENT 	
    # * ERR_NOTEXTTOSEND
    # * ERR_CANNOTSENDTOCHAN 	
    # * ERR_NOTOPLEVEL
    # * ERR_WILDTOPLEVEL 	
    # * ERR_TOOMANYTARGETS
    # * ERR_NOSUCHNICK 	
    # * RPL_AWAY 	
    # 
    # Examples:
    # 
    # :Angel PRIVMSG Wiz :Hello are you receiving this message ?
    #                        ; Message from Angel to Wiz.
    # 
    # PRIVMSG Angel :yes I'm receiving it !receiving it !'u>(768u+1n) .br
    #                        ; Message to Angel.
    # 
    # PRIVMSG jto@tolsun.oulu.fi :Hello !
    #                        ; Message to a client on server
    #                        tolsun.oulu.fi with username of "jto".
    # 
    # PRIVMSG $*.fi :Server tolsun.oulu.fi rebooting.
    #                        ; Message to everyone on a server which
    #                        has a name matching *.fi.
    # 
    # PRIVMSG #*.edu :NSFNet is undergoing work, expect interruptions
    #                        ; Message to all users who come from a
    #                        host which has a name matching *.edu.
    class PrivateMessage < Message
    
      CODE = "PRIVMSG"

      attr_reader :target      
      attr_reader :sender
      attr_reader :text
      
      # Notify all connection listeners, that a private message was received.
      def handle(context)
        
        # Notify all connection listeners by calling their on_server_response method.
        super(context)
        
        # Notify all connection listeners by calling their on_private_message method.
        notify(context) do |connection_listener| 
          connection_listener.on_private_message(context, IRC::Models::Channel.is_valid?(target) ? context.lookup_channel(target) : context.lookup_user(target), text)
        end

      end
      
      protected      
      
      def parse(raw_message)

        # Initialize the base message fields.
        super(raw_message)      

        # Extract the message specific fields.
        match_data = Regexp.new('(\S+)\s+:?(.+)').match(message)
        raise InvalidMessage.new("Can't parse private message. Invalid message format.") if match_data == nil || code != CODE

        # Extract the sender, target and the text.
        @sender, @target, @text = nick, match_data[1], match_data[2]
        
      end
      
    end      
    
  end
  
end  