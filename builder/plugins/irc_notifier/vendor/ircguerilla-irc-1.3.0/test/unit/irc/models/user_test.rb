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
# $Id: user_test.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/models/channel'
require 'irc/models/network'
require 'irc/models/server'
require 'irc/models/user'
require 'test/unit'

class IRC::Models::UserTest < Test::Unit::TestCase

  def setup
    @network = IRC::Models::Network.new(:name => 'Efnet')
  end
  
  def test_key
    network = IRC::Models::Network.new(:name => 'Efnet')
    user = network.create_user('iRCGUERillA')
    assert_equal 'efnet|ircguerilla', user.key
  end

#  def test_equal
#    assert_equal IRC::Models::User.new(@network, 'tom'), IRC::Models::User.new(@network, 'tom')
#    assert_equal IRC::Models::User.new(@network, 'tom', 'tom1'), IRC::Models::User.new(@network, 'tom', 'tom2')
#    assert_equal IRC::Models::User.new(@network, 'tom', 'tom1', 'yahoo.com'), IRC::Models::User.new(@network, 'tom', 'tom2', 'google.com')
#    assert_not_equal IRC::Models::User.new(@network, 'tom'), IRC::Models::User.new(@network, 'jerry')                
#    assert_not_equal IRC::Models::User.new(IRC::Models::Network.new('Undernet'), 'tom'), IRC::Models::User.new(@network, 'tom')        
#  end
#  
  def test_add_channel(nick = "ircguerilla", channel_name = "#ircguerilla")
    channel = @network.create_channel(channel_name)
    user = @network.create_user(nick)
    user.add_channel(channel)
    assert user.channels.include?(channel)
  end
  
  def test_remove_channel(nick = "ircguerilla", channel_name = "#ircguerilla")
    test_add_channel(nick, channel_name)
    user = @network.lookup_user(nick)
    channel = @network.lookup_channel(channel_name)
    user.remove_channel(channel)
    assert !user.channels.include?(channel)    
  end
  
end
