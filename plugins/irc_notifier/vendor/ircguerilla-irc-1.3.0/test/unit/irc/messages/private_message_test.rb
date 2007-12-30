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
require 'irc/messages/invalid_message'
require 'irc/messages/message_test'
require 'irc/messages/private_message'
require 'test/unit'

class IRC::Messages::PrivateMessageTest < IRC::Messages::MessageTest
  
  # This method gets called when a private message was received from a channel or an user.
  def on_private_message(connection, target, message)
    @target, @message = target, message
  end
  
  def test_message

    message = IRC::Messages::PrivateMessage.new(":Angel PRIVMSG Wiz :Hello are you receiving this message ?")
    assert_equal "Angel", message.sender
    assert_equal "Angel", message.nick    
    assert_equal "Wiz", message.target
    assert_equal "Hello are you receiving this message ?", message.text    
     
  end
  
  def test_handle
  
    # Simulate a connection registration.
    connection.add_connection_listener(self)
    connection.connect(server)
    connection.register
      
    message = IRC::Messages::PrivateMessage.new(":Angel PRIVMSG Wiz :Hello are you receiving this message ?")
    message.handle(connection.context)
    
    assert_equal "Wiz", @target.nick
    assert_equal "Hello are you receiving this message ?", @message
      
  end  
  
end