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
# $Id: nick_message_test.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/messages/invalid_message'
require 'irc/messages/notice_message'
require 'irc/messages/message_test'
require 'test/unit'

class IRC::Messages::NoticeMessageTest < IRC::Messages::MessageTest
  
  # This method gets called when a notice message was received.
  def on_notice(connection, user, message)
    @user, @message = user, message
  end  
  
  def test_invalid_messages
    assert_raise(IRC::Messages::InvalidMessage) { IRC::Messages::NoticeMessage.new("") }
    assert_raise(IRC::Messages::InvalidMessage) { IRC::Messages::NoticeMessage.new("NOTICE") }    
  end
  
  def test_notice
    message = IRC::Messages::NoticeMessage.new("NOTICE AUTH :*** Looking up your hostname...")
    assert_equal "AUTH", message.nick
    assert_equal "*** Looking up your hostname...", message.message
  end
  
  def test_handle
  
    # Simulate a connection registration.
    connection.add_connection_listener(self)
    connection.connect(server)
    connection.register
      
    message = IRC::Messages::NoticeMessage.new("NOTICE AUTH :*** Looking up your hostname...")
    message.handle(connection.context)
    
    assert_equal "AUTH", @user.nick
    assert_equal "*** Looking up your hostname...", @message
          
  end  
  
end