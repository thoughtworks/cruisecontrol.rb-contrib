
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
require 'irc/messages/error_join_message'
require 'test/unit'

class IRC::Messages::ErrorJoinMessageTest < IRC::Messages::MessageTest

  # This message gets called when a channel join attempt failed.
  def on_join_failure(connection, channel, code, reason)
    @channel, @code, @reason = channel, code, reason
  end  
  
  def test_error_no_such_channel
    
    message = IRC::Messages::ErrorJoinMessage.new(":irc.easynews.com 403 fumanshu invalid :No such channel")
    assert_equal "irc.easynews.com", message.server
    assert_equal 403, message.code
    assert_equal "fumanshu", message.nick
    assert_equal "invalid", message.channel
    assert_equal "No such channel", message.reason
    
  end
  
  def test_handle_error_no_such_channel
  
    # Simulate a connection registration.
    connection.add_connection_listener(self)
    connection.connect(server)
    connection.register
      
    message = IRC::Messages::ErrorJoinMessage.new(":irc.easynews.com 403 fumanshu invalid :No such channel")
    message.handle(connection.context)
    
    assert_equal "invalid", @channel.name
    assert_equal 403, @code
    assert_equal "No such channel", @reason
        
  end  
  
end