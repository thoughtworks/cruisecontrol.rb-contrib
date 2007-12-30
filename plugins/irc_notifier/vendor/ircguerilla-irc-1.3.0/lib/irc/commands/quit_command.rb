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
# $Id: quit_command.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/commands/command'
require 'irc/commands/invalid_command'

module IRC
  
  module Commands
    
    # 4.1.6 Quit
    # 
    # Command: 	    QUIT
    # Parameters: 	[<Quit message>]
    # 
    # A client session is ended with a quit message. The server must close the 
    # connection to a client which sends a QUIT message. If a "Quit Message" is 
    # given, this will be sent instead of the default message, the nickname.
    # 
    # When netsplits (disconnecting of two servers) occur, the quit message is 
    # composed of the names of two servers involved, separated by a space. The 
    # first name is that of the server which is still connected and the second 
    # name is that of the server that has become disconnected.
    # 
    # If, for some other reason, a client connection is closed without the 
    # client issuing a QUIT command (e.g. client dies and EOF occurs on socket), 
    # the server is required to fill in the quit message with some sort of message 
    # reflecting the nature of the event which caused it to happen.
    # 
    # Numeric Replies:
    # 
    # None.
    # 
    # Examples:
    # 
    # QUIT :Gone to have lunch     ; Preferred message format.
    # 
    class QuitCommand < Command
      
      attr_reader :message
      
      def initialize(message)
        
        raise InvalidCommand.new("Can't create quit command. No quit message.") unless message
        @message = message
        
        super(command)      
                
      end
      
      def command 
        return "QUIT :#{message}"
      end
      
    end      
    
  end
  
end  