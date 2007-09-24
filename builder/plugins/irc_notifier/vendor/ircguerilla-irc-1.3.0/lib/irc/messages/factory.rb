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
# $Id: factory.rb 93 2006-08-13 21:30:53Z roman $
# 
require 'irc/messages/message'
require 'irc/messages/error_message'
require 'irc/messages/error_nick_name_in_use_message'
require 'irc/messages/isupport_message'
require 'irc/messages/join_message'
require 'irc/messages/kick_message'
require 'irc/messages/nick_message'
require 'irc/messages/notice_message'
require 'irc/messages/part_message'
require 'irc/messages/ping_message'
require 'irc/messages/pong_message'
require 'irc/messages/private_message'
require 'irc/messages/welcome_message'

module IRC
  
  module Messages
    
    class Factory
      
      def self.create(raw_message)
      
        # Remove new line from raw message if available.
        raw_message.chomp!

        # Create a new message object, to get access to the message code.        
        message = Message.new(raw_message)
        
        # Create a new specialized message object, depending on the message code.
        case message.code     
        
        when ErrorMessage::CODE
          return ErrorMessage.new(raw_message)
        
        when ErrorAlreadyRegisteredMessage::CODE
          return ErrorAlreadyRegisteredMessage.new(raw_message)
        
        when ErrorBadChannelKeyMessage::CODE
          return ErrorBadChannelKeyMessage.new(raw_message)   
          
        when ErrorBadChannelMaskMessage::CODE
          return ErrorBadChannelMaskMessage.new(raw_message)          
          
        when ErrorBannedFromChannelMessage::CODE
          return ErrorBannedFromChannelMessage.new(raw_message)
          
        when ErrorChannelIsFulMessage::CODE
          return ErrorChannelIsFulMessage.new(raw_message)
        
        when ErrorErroneusNickNameMessage::CODE
          return ErrorErroneusNickNameMessage.new(raw_message)
          
        when ErrorInviteOnlyChannelMessage::CODE
          return ErrorInviteOnlyChannelMessage.new(raw_message)
          
        when ErrorNeedMoreParametersMessage::CODE
          return ErrorNeedMoreParametersMessage.new(raw_message)                    

        when ErrorNickCollisionMessage::CODE
          return ErrorNickCollisionMessage.new(raw_message)

        when ErrorNickNameInUseMessage::CODE
          return ErrorNickNameInUseMessage.new(raw_message)

        when ErrorNoNickNameGivenMessage::CODE
          return ErrorNoNickNameGivenMessage.new(raw_message)
        
        when ErrorNoOriginMessage::CODE
          return ErrorNoOriginMessage.new(raw_message)
          
        when ErrorNoSuchChannelMessage::CODE
          return ErrorNoSuchChannelMessage.new(raw_message)
        
        when ErrorNoSuchServerMessage::CODE
          return ErrorNoSuchServerMessage.new(raw_message)
          
        when ErrorNotOnChannelMessage::CODE
          return ErrorNotOnChannelMessage.new(raw_message)          
          
        when ErrorTooManyChannelsMessage::CODE
          return ErrorTooManyChannelsMessage.new(raw_message)             
          
        when ISupportMessage::CODE
          return ISupportMessage.new(raw_message)             

        when JoinMessage::CODE
          return JoinMessage.new(raw_message)
          
        when KickMessage::CODE
          return KickMessage.new(raw_message)
          
        when NickMessage::CODE
          return NickMessage.new(raw_message)

        when NoticeMessage::CODE
          return NoticeMessage.new(raw_message)

        when PartMessage::CODE
          return PartMessage.new(raw_message)
          
        when PingMessage::CODE
          return PingMessage.new(raw_message)          

        when PongMessage::CODE
          return PongMessage.new(raw_message)          

        when PrivateMessage::CODE
          return PrivateMessage.new(raw_message)
          
        when WelcomeMessage::CODE
          return WelcomeMessage.new(raw_message)
          
        end
        
        return message
        
      end
      
    end
    
  end
  
end