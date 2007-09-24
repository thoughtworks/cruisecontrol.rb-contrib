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
# $Id: pong_command.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/commands/command'
require 'irc/commands/invalid_command'

module IRC
  
  module Commands
    
    # 4.6.3 Pong message
    # 
    # Command: 	    PONG
    # Parameters: 	<daemon> [<daemon2>]
    # 
    # PONG message is a reply to ping message. If parameter <daemon2> is given this message must 
    # be forwarded to given daemon. The <daemon> parameter is the name of the daemon who has responded 
    # to PING message and generated this message.
    # 
    # Numeric Replies:
    # * ERR_NOORIGIN 
    # *	ERR_NOSUCHSERVER
    # 
    # Examples:
    # 
    # PONG csd.bu.edu tolsun.oulu.fi  ; PONG message from csd.bu.edu to
    # 
    class PongCommand < Command
      
      attr_reader :first_daemon
      attr_reader :second_daemon      
      
      def initialize(first_daemon, second_daemon = nil)

        raise InvalidCommand.new("Can't create ping command. No daemon.") unless first_daemon
        @first_daemon, @second_daemon = first_daemon, second_daemon
        super(command)              
        
      end
      
      def command
        return "PONG #{first_daemon} #{second_daemon != nil ? second_daemon.to_s : ''}".strip
      end
      
    end      
  
  end
  
end  
