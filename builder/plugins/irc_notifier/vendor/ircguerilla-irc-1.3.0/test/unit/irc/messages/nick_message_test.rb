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
# $Id: nick_message_test.rb 89 2006-08-13 14:03:35Z roman $
# 
require 'irc/messages/invalid_message'
require 'irc/messages/message_test'
require 'irc/messages/nick_message'
require 'test/unit'

class IRC::Messages::NickMessageTest < IRC::Messages::MessageTest 
  
  # This method gets called when a user changes it's nick name.
  def on_nick(connection, before, after)
    @before, @after = before, after
  end
  
  def test_invalid_messages
    
    assert_raise(IRC::Messages::InvalidMessage) { IRC::Messages::NickMessage.new("") }
    assert_raise(IRC::Messages::InvalidMessage) { IRC::Messages::NickMessage.new("NICK") }    
    
    # This is a command, not a message! 
    assert_raise(IRC::Messages::InvalidMessage) { IRC::Messages::NickMessage.new("NICK Kilroy") }
    
  end
  
  def test_nick_change
    message = IRC::Messages::NickMessage.new(":WiZ NICK Kilroy")
    assert_equal "Kilroy", message.after
    assert_equal "WiZ", message.before
  end
  
  def test_handle
  
    # Simulate a connection registration.
    connection.add_connection_listener(self)
    connection.connect(server)
    connection.register
      
    message = IRC::Messages::NickMessage.new(":WiZ NICK Kilroy")
    message.handle(connection.context)
    
    assert_equal "WiZ", @before.nick
    assert_equal "Kilroy", @after.nick
      
  end    
  
end