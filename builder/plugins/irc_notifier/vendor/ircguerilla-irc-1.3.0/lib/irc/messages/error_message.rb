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
# $Id: error_message.rb 94 2006-08-13 21:40:40Z roman $
# 
require 'irc/messages/error_join_message'
require 'irc/messages/message'
require 'irc/messages/invalid_message'

module IRC
  
  module Messages
    
    class ErrorMessage < Message
      
      CODE = "ERROR"
      
      attr_reader :reason
      
      # Notify all connection listeners, that a user changed it's nick name.
      def handle(context)
        
        # Notify all connection listeners by calling their on_server_response method.
        super(context)
        
        # Notify all connection listeners by calling their on_nick method.
        notify(context) do |connection_listener| 
          connection_listener.on_error(context, reason)
        end
        
      end
      
      protected      
      
      def parse(raw_message)
        
        # Initialize the base message fields.
        super(raw_message)      
        
        # Match the message against the message format.
        match_data = Regexp.new('\s*ERROR\s+:?(.+)').match(raw_message)
        raise InvalidMessage.new("Can't parse error message. Invalid message format.") unless match_data
        
        @reason = match_data[1]

      end      
      
    end      
    
#    class JoinFailureMessage < Message
#    end
#    
#    class PartFailureMessage < Message
#    end
    
    class ErrorAlreadyRegisteredMessage < Message
      CODE = ERR_ALREADYREGISTRED
    end
    
    class ErrorBadChannelKeyMessage < ErrorJoinMessage
      CODE = ERR_BADCHANNELKEY
    end          
    
    class ErrorBadChannelMaskMessage < ErrorJoinMessage
      CODE = ERR_BADCHANMASK
    end          
    
    class ErrorBannedFromChannelMessage < ErrorJoinMessage
      CODE = ERR_BANNEDFROMCHAN
    end          
    
    class ErrorChannelIsFulMessage < ErrorJoinMessage
      CODE = ERR_CHANNELISFULL
    end          
    
    class ErrorErroneusNickNameMessage < Message
      CODE = ERR_ERRONEUSNICKNAME
    end      
    
    class ErrorInviteOnlyChannelMessage < ErrorJoinMessage
      CODE = ERR_INVITEONLYCHAN
    end      
    
    class ErrorNeedMoreParametersMessage < Message
      CODE = ERR_NEEDMOREPARAMS
    end          
    
    class ErrorNickCollisionMessage < Message
      CODE = ERR_NICKCOLLISION
    end      
    
    class ErrorNoNickNameGivenMessage < Message
      CODE = ERR_NONICKNAMEGIVEN
    end      
    
    class ErrorNoOriginMessage < Message
      CODE = ERR_NOORIGIN
    end
    
    class ErrorNoSuchChannelMessage < ErrorJoinMessage
      CODE = ERR_NOSUCHCHANNEL
    end      
    
    class ErrorNoSuchServerMessage < Message
      CODE = ERR_NOSUCHSERVER
    end      
    
    class ErrorNotOnChannelMessage < Message
      CODE = ERR_NOTONCHANNEL
    end 
    
    class ErrorTooManyChannelsMessage < ErrorJoinMessage
      CODE = ERR_TOOMANYCHANNELS
    end      
    
  end
  
end  