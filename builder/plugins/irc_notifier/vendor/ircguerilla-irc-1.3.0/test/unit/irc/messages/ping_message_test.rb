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
# $Id: ping_message_test.rb 93 2006-08-13 21:30:53Z roman $
# 
require 'irc/messages/invalid_message'
require 'irc/messages/message_test'
require 'irc/messages/ping_message'
require 'test/unit'

class IRC::Messages::PingMessageTest < IRC::Messages::MessageTest

  # This method gets called when a ping message was received from the server.
  def on_ping(connection, servers)
    @servers = servers
  end
  
  def test_invalid_messages
    assert_raise(IRC::Messages::InvalidMessage) { IRC::Messages::PingMessage.new("") }
    assert_raise(IRC::Messages::InvalidMessage) { IRC::Messages::PingMessage.new("PING") }
  end
  
  def test_server

    message = IRC::Messages::PingMessage.new("PING tolsun.oulu.fi")
    assert_equal ["tolsun.oulu.fi"], message.servers

    message = IRC::Messages::PingMessage.new("PING :302757EC")
    assert_equal ["302757EC"], message.servers
     
  end

  def test_servers

    message = IRC::Messages::PingMessage.new("PING tolsun.oulu.fi irc.efnet.pl")
    assert_equal ["tolsun.oulu.fi", "irc.efnet.pl"], message.servers
    
    message = IRC::Messages::PingMessage.new("PING :tolsun.oulu.fi :irc.efnet.pl")
    assert_equal ["tolsun.oulu.fi", "irc.efnet.pl"], message.servers
    
  end
  
  def test_handle
  
    # Simulate a connection registration.
    connection.add_connection_listener(self)
    connection.connect(server)
    connection.register
      
    message = IRC::Messages::PingMessage.new("PING tolsun.oulu.fi irc.efnet.pl")
    message.handle(connection.context)
    
    assert_equal ["tolsun.oulu.fi", "irc.efnet.pl"], @servers
      
  end  
  
end