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
require 'irc/messages/error_message'
require 'test/unit'

class IRC::Messages::ErrorMessageTest < IRC::Messages::MessageTest 
  
  # This method gets called an error message was received from the IRC server.
  def on_error(connection, reason)
    @reason = reason
  end
  
  def test_message
    message = IRC::Messages::ErrorMessage.new("ERROR :Closing Link: 85.178.111.249 (*** Banned (cache))")
    assert_equal "Closing Link: 85.178.111.249 (*** Banned (cache))", message.reason
  end
  
  def test_handle
  
    # Simulate a connection registration.
    connection.add_connection_listener(self)
    connection.connect(server)
    connection.register
      
    message = IRC::Messages::ErrorMessage.new("ERROR :Closing Link: 85.178.111.249 (*** Banned (cache))")
    message.handle(connection.context)
    assert_equal "Closing Link: 85.178.111.249 (*** Banned (cache))", @reason
      
  end    
  
end