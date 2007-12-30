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
require 'irc/messages/error_nick_name_in_use_message'
require 'test/unit'

class IRC::Messages::ErrorNickNameInUseMessageTest < IRC::Messages::MessageTest 
  
  # This method gets called when the chosen nick name is already in use.
  def on_nick_already_in_use(connection, nick_name_in_use)
    @nick_name_in_use = nick_name_in_use
  end
  
  def test_nick_change
    message = IRC::Messages::ErrorNickNameInUseMessage.new(":irc.easynews.com 433 * fumanshu :Nickname is already in use.")
    assert_equal "fumanshu", message.nick_name_in_use
  end
  
  def test_handle
  
    # Simulate a connection registration.
    connection.add_connection_listener(self)
    connection.connect(server)
    connection.register
      
    message = IRC::Messages::ErrorNickNameInUseMessage.new(":irc.easynews.com 433 * fumanshu :Nickname is already in use.")
    message.handle(connection.context)
    assert_equal "fumanshu", @nick_name_in_use
      
  end    
  
end