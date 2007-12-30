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
# $Id: pong_message_test.rb 93 2006-08-13 21:30:53Z roman $
# 
require 'irc/messages/invalid_message'
require 'irc/messages/message_test'
require 'irc/messages/pong_message'
require 'test/unit'

class IRC::Messages::PongMessageTest < IRC::Messages::MessageTest

  # This method gets called when a pong message was received from the server.
  def on_pong(connection, daemons)
    @daemons = daemons
  end
  
  def test_invalid_messages
    assert_raise(IRC::Messages::InvalidMessage) { IRC::Messages::PongMessage.new("") }
    assert_raise(IRC::Messages::InvalidMessage) { IRC::Messages::PongMessage.new("PONG") }
  end
  
  def test_daemon

    message = IRC::Messages::PongMessage.new("PONG csd.bu.edu")
    assert_equal ["csd.bu.edu"], message.daemons
    
    message = IRC::Messages::PongMessage.new("PONG :csd.bu.edu")
    assert_equal ["csd.bu.edu"], message.daemons
    
  end

  def test_daemons

    message = IRC::Messages::PongMessage.new("PONG csd.bu.edu tolsun.oulu.fi")
    assert_equal ["csd.bu.edu", "tolsun.oulu.fi"], message.daemons
    
    message = IRC::Messages::PongMessage.new("PONG :csd.bu.edu :tolsun.oulu.fi")
    assert_equal ["csd.bu.edu", "tolsun.oulu.fi"], message.daemons
    
  end
  
  def test_handle
  
    # Simulate a connection registration.
    connection.add_connection_listener(self)
    connection.connect(server)
    connection.register
      
    message = IRC::Messages::PongMessage.new("PONG csd.bu.edu tolsun.oulu.fi")
    message.handle(connection.context)
    
    assert_equal ["csd.bu.edu", "tolsun.oulu.fi"], @daemons
      
  end    
  
end