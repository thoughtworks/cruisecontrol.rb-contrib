
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
require 'irc/messages/join_message'
require 'irc/messages/message_test'
require 'test/unit'

class IRC::Messages::PartMessageTest < IRC::Messages::MessageTest
  
  # This method gets called when a user (possibly us) leaves a channel.
  def on_part(connection, channel, user)
    @channel, @user = channel, user
  end
        
  def test_part
  
    message = IRC::Messages::PartMessage.new(":WiZ PART #Twilight_zone")
    assert_equal "WiZ", message.nick
    assert_equal "#Twilight_zone", message.channel
    
    message = IRC::Messages::PartMessage.new(":fumanshu!g3jE7XnP@e178069051.adsl.alicedsl.de PART #ircguerilla")
    assert_equal "fumanshu", message.nick
    assert_equal "g3jE7XnP", message.login
    assert_equal "e178069051.adsl.alicedsl.de", message.host
    assert_equal "#ircguerilla", message.channel
    
  end
  
  def test_handle
  
    # Simulate a connection registration.
    connection.add_connection_listener(self)
    connection.connect(server)
    connection.register
      
    message = IRC::Messages::PartMessage.new(":fumanshu!g3jE7XnP@e178069051.adsl.alicedsl.de PART #ircguerilla")
    message.handle(connection.context)
    
    assert_equal "#ircguerilla", @channel.name
    assert_equal "fumanshu", @user.nick
      
  end  
  
end