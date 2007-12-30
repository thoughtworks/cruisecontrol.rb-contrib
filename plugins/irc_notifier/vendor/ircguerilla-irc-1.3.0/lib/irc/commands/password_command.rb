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
# $Id: password_command.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/commands/command'
require 'irc/commands/invalid_command'

module IRC
  
  module Commands
    
    # 4.1.1 Password message
    # 
    # Command:	PASS
    # Parameters:	<password>
    # 
    # The PASS command is used to set a 'connection password'. The password can and must 
    # be set before any attempt to register the connection is made. Currently this requires 
    # that clients send a PASS command before sending the NICK/USER combination and servers 
    # *must* send a PASS command before any SERVER command. The password supplied must match 
    # the one contained in the C/N lines (for servers) or I lines (for clients). It is 
    # possible to send multiple PASS commands before registering but only the last one sent 
    # is used for verification and it may not be changed once registered. 
    # 
    # Numeric Replies:
    # 
    # ERR_NEEDMOREPARAMS 	
    # ERR_ALREADYREGISTRED
    # 
    # Example:
    # 
    # PASS secretpasswordhere
    #   
    class PasswordCommand < Command
      
      attr_reader :password
      
      def initialize(password)
        raise InvalidCommand.new("Can't create password command. No password.") unless password
        @password = password
        super(command)              
      end
      
      def command 
        return "PASS #{password}"
      end
      
    end      
    
  end
  
end  