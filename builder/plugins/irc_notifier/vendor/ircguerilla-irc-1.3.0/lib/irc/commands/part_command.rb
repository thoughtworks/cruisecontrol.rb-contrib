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
# $Id: part_command.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/commands/command'
require 'irc/commands/invalid_command'

module IRC
  
  module Commands
    
    # 4.2.2 Part message
    # 
    # Command: 	    PART
    # Parameters: 	<channel>{,<channel>}
    # 
    # The PART message causes the client sending the message to be removed 
    # from the list of active users for all given channels listed in the 
    # parameter string.
    # 
    # Numeric Replies:
    # 
    # ERR_NEEDMOREPARAMS 	
    # ERR_NOSUCHCHANNEL
    # ERR_NOTONCHANNEL 	
    # 
    # Examples:
    # 
    # PART #twilight_zone    ; leave channel "#twilight_zone"
    # 
    # PART #oz-ops,&group5   ; leave both channels "&group5" and
    #                        ; "#oz-ops".
    # 
    class PartCommand < Command
      
      attr_reader :channels
      
      def initialize(channels)

        raise InvalidCommand.new("Can't create part command. No channels.") unless channels
        
        if channels.instance_of?(Array)
        
          @channels = channels
        
        else
        
          @channels = Array.new
          @channels << channels
                  
        end
        
        super(command)              
        
      end
      
      def command 
        return "PART #{channels.join(',')}"
      end
      
    end      
    
  end
  
end  