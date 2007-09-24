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
require 'irc/messages/kick_message'
require 'irc/messages/message_test'
require 'test/unit'

class IRC::Messages::KickMessageTest < IRC::Messages::MessageTest 

  # This method gets called when a user gets kicked from a channel.
  def on_kick(connection, channel, kicker_user, kicked_user, reason)
    @connection, @channel, @kicker_user, @kicked_user, @reason = connection, channel, kicker_user, kicked_user, reason
#    puts channel.class
  end
  
  def test_join

    message = IRC::Messages::KickMessage.new(":vacant!hollow@64.18.146.82 KICK #dnbarena fumanshu :Drone")
    assert_equal "vacant", message.nick
    assert_equal "hollow", message.login
    assert_equal "64.18.146.82", message.host
    assert_equal "fumanshu", message.kicked
    assert_equal "vacant", message.kicker
    assert_equal "Drone", message.reason
    
    message = IRC::Messages::KickMessage.new(":WiZ KICK #Finnish John")
    assert_equal "WiZ", message.nick
    assert_nil message.login
    assert_nil message.host
    assert_equal "John", message.kicked
    assert_equal "WiZ", message.kicker
    assert_nil message.reason
    
  end
  
  def test_handle
  
    # Simulate a connection registration.
    connection.add_connection_listener(self)
    connection.connect(server)
    connection.register
      
    message = IRC::Messages::KickMessage.new(":vacant!hollow@64.18.146.82 KICK #dnbarena fumanshu :Drone")
    message.handle(connection.context)
    
    assert_equal "#dnbarena", @channel.name
    assert_equal "vacant", @kicker_user.nick
    assert_equal "fumanshu", @kicked_user.nick
    assert_equal "Drone", @reason
      
  end
  
end
