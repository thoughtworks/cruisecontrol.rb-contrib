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
# $Id: nick_message.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/messages/message'
require 'irc/messages/invalid_message'

module IRC
  
  module Messages
    
    # 4.4.2 Notice
    # 
    # Command: 	    NOTICE
    # Parameters: 	<nickname> <text>
    # 
    # The NOTICE message is used similarly to PRIVMSG. The difference between NOTICE and PRIVMSG is 
    # that automatic replies must never be sent in response to a NOTICE message. This rule applies 
    # to servers too - they must not send any error reply back to the client on receipt of a notice. 
    # The object of this rule is to avoid loops between a client automatically sending something in 
    # response to something it received. This is typically used by automatons (clients with either 
    # an AI or other interactive program controlling their actions) which are always seen to be 
    # replying lest they end up in a loop with another automaton.
    # 
    # See PRIVMSG for more details on replies and examples.
    # 
    class NoticeMessage < Message
    
      CODE = "NOTICE"

      attr_reader :message
      
      # Notify all connection listeners, that a notice message was received.
      def handle(context)
        
        # Notify all connection listeners by calling their on_server_response method.
        super(context)
        
        # Notify all connection listeners by calling their on_notice method.
        notify(context) do |connection_listener| 
          connection_listener.on_notice(context, context.lookup_user(nick), message)
        end

      end
      
      protected
      
      def parse(raw_message)

        # Initialize the base message fields.
        super(raw_message)      

        # Match the message against the message format.
        match_data = Regexp.new('\s*NOTICE\s+:?(\S+)\s+:?(.*)').match(raw_message)
        raise InvalidMessage.new("Can't parse notice message. Invalid message format.") unless match_data

        # Initialize the nick & message fileds.
        @nick, @message = match_data[1].strip, match_data[2].strip
        
      end
      
    end      
    
  end
  
end  