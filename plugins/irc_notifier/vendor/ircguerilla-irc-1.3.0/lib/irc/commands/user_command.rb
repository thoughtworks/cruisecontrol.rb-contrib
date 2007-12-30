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
# $Id: user_command.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/commands/command'
require 'irc/commands/invalid_command'

module IRC
  
  module Commands
    
    # Command: 	USER
    # 
    # Parameters: 	<username> <hostname> <servername> <realname>
    # 
    # The USER message is used at the beginning of connection to specify the 
    # username, hostname, servername and realname of s new user. It is also 
    # used in communication between servers to indicate new user arriving on 
    # IRC, since only after both USER and NICK have been received from a client 
    # does a user become registered.
    # 
    # Between servers USER must to be prefixed with client's NICKname. Note that 
    # hostname and servername are normally ignored by the IRC server when the USER 
    # command comes from a directly connected client (for security reasons), but 
    # they are used in server to server communication. This means that a NICK must 
    # always be sent to a remote server when a new user is being introduced to the 
    # rest of the network before the accompanying USER is sent.
    # 
    # It must be noted that realname parameter must be the last parameter, because 
    # it may contain space characters and must be prefixed with a colon (':') to 
    # make sure this is recognised as such.
    # 
    # Since it is easy for a client to lie about its username by relying solely on 
    # the USER message, the use of an "Identity Server" is recommended. If the host 
    # which a user connects from has such a server enabled the username is set to 
    # that as in the reply from the "Identity Server".
    # 
    # Numeric Replies:
    # 
    # * ERR_NEEDMOREPARAMS 	
    # * ERR_ALREADYREGISTRED
    # 
    # Examples:
    # 
    # User registering themselves with a username of "guest" and real name "Ronnie Reagan".
    # 
    # USER guest tolmoon tolsun :Ronnie Reagan            
    # 
    # Message between servers with the nickname for which the USER command belongs to
    # 
    # :testnick USER guest tolmoon tolsun :Ronnie Reagan  
    # 
    class UserCommand < Command
      
      attr_reader :user
      attr_reader :host
      attr_reader :server
      attr_reader :realname
      
      def initialize(user, host, server, realname)

        raise InvalidCommand.new("Can't create user command. User name is missing.") unless user
        @user = user
        
        raise InvalidCommand.new("Can't create user command. Host is missing.") unless host        
        @host = host
        
        raise InvalidCommand.new("Can't create user command. Server is missing.") unless server        
        @server = server
        
        raise InvalidCommand.new("Can't create user command. Real name is missing.") unless realname        
        @realname = realname

        super(command)      
                
      end
      
      def command 
        return "USER #{user} #{host} #{server} :#{realname}"
      end
      
    end      
    
  end
  
end  