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
# $Id: join_command.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/commands/command'
require 'irc/commands/invalid_command'
require 'irc/messages/codes'

module IRC
  
  module Commands
    
    # 4.2.1 Join message
    # 
    # Command: 	    JOIN
    # Parameters: 	<channel>{,<channel>} [<key>{,<key>}]
    # 
    # The JOIN command is used by client to start listening a specific channel. 
    # Whether or not a client is allowed to join a channel is checked only by 
    # the server the client is connected to; all other servers automatically add 
    # the user to the channel when it is received from other servers. The conditions 
    # which affect this are as follows:
    # 
    #    1. the user must be invited if the channel is invite-only;
    #    2. the user's nick/username/hostname must not match any active bans;
    #    3. the correct key (password) must be given if it is set.
    # 
    # These are discussed in more detail under the MODE command (see section 4.2.3 
    # for more details).
    # 
    # Once a user has joined a channel, they receive notice about all commands their 
    # server receives which affect the channel. This includes MODE, KICK, PART, QUIT 
    # and of course PRIVMSG/NOTICE. The JOIN command needs to be broadcast to all 
    # servers so that each server knows where to find the users who are on the channel. 
    # This allows optimal delivery of PRIVMSG/NOTICE messages to the channel.
    #
    # If a JOIN is successful, the user is then sent the channel's topic (using 
    # RPL_TOPIC) and the list of users who are on the channel (using RPL_NAMREPLY), 
    # which must include the user joining.
    # 
    # Numeric Replies:
    # 
    # * ERR_NEEDMOREPARAMS 	
    # * ERR_BANNEDFROMCHAN
    # * ERR_INVITEONLYCHAN 	
    # * ERR_BADCHANNELKEY
    # * ERR_CHANNELISFULL 	
    # * ERR_BADCHANMASK
    # * ERR_NOSUCHCHANNEL 	
    # * ERR_TOOMANYCHANNELS
    # * RPL_TOPIC 	
    # 
    # Examples:
    # 
    # JOIN #foobar                ; join channel #foobar.
    # 
    # JOIN &foo fubar             ; join channel &foo using key "fubar".
    # 
    # JOIN #foo,&bar fubar        ; join channel #foo using key "fubar"
    #                             ; and &bar using no key.
    # 
    # JOIN #foo,#bar fubar,foobar ; join channel #foo using key "fubar".
    #                             ; and channel #bar using key "foobar".
    # 
    # JOIN #foo,#bar              ; join channels #foo and #bar.
    # 
    # :WiZ JOIN #Twilight_zone    ; JOIN message from WiZ
    #    
    class JoinCommand < Command
      
      attr_reader :channels
      attr_reader :passwords
      
      def initialize(channels, passwords = [])

        raise InvalidCommand.new("Can't create join command. No channels.") unless channels
        
        if channels.instance_of?(Array)
          @channels = channels
        else
          @channels = Array.new
          @channels << channels
        end
        
        if passwords.instance_of?(Array)
          @passwords = passwords
        else
          @passwords = Array.new
          @passwords << passwords
        end
        
        super(command)      
                
      end
      
      def command 
        return "JOIN #{channels.join(',')} #{passwords.join(',')}".strip
      end
      
      # Returns true, if the message is a valid response to the command. 
      def valid_response?(message)

        valid_reponse_codes = [IRC::Messages::Codes::ERR_NEEDMOREPARAMS, IRC::Messages::Codes::ERR_BANNEDFROMCHAN, 
          IRC::Messages::Codes::ERR_INVITEONLYCHAN, IRC::Messages::Codes::ERR_BADCHANNELKEY, IRC::Messages::Codes::ERR_CHANNELISFULL, 	
          IRC::Messages::Codes::ERR_BADCHANMASK, IRC::Messages::Codes::ERR_NOSUCHCHANNEL, IRC::Messages::Codes::ERR_TOOMANYCHANNELS,
          IRC::Messages::Codes::RPL_TOPIC]
          
        return valid_reponse_codes.include?(message.code)

      end
      
    end      
    
  end
  
end  