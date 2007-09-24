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
# $Id: channel_test.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'yaml'
require 'irc/models/channel'
require 'irc/models/network'
require 'irc/models/server'
require 'irc/models/user'
require 'test/unit'

class IRC::Models::ChannelTest < Test::Unit::TestCase

  def setup
    @network = IRC::Models::Network.new(:name => 'Efnet')
  end
  
  def test_key
    network = IRC::Models::Network.new(:name => 'Efnet')
    channel = network.create_channel('#ircguerilla')
    assert_equal 'efnet|#ircguerilla', channel.key
  end

  def test_equal

    assert_equal IRC::Models::Channel.new(:network => @network, :name => '#channel'), IRC::Models::Channel.new(:network => @network, :name => '#channel')
    
    assert_not_equal IRC::Models::Channel.new(:network => @network, :name => '#channel'), IRC::Models::Channel.new(:network => @network, :name => '#other')    
    assert_not_equal IRC::Models::Channel.new(:network => IRC::Models::Network.new(:name => 'Undernet'), :name => '#channel'), IRC::Models::Channel.new(:network => @network, :name => '#channel')        
      
  end
  
  def test_left_shift

    channel_name = ""
    
    channel = @network.create_channel("#channel")
    channel_name << channel
    assert_equal "#channel", channel_name
  
  end
  
  def test_is_valid
    assert IRC::Models::Channel.is_valid?("#channel") == true
    assert IRC::Models::Channel.is_valid?("&channel") == true    
    assert IRC::Models::Channel.is_valid?(" #channel") == true
    assert IRC::Models::Channel.is_valid?(" &channel") == true    
    assert IRC::Models::Channel.is_valid?("") == false    
    assert IRC::Models::Channel.is_valid?("   ") == false        
    assert IRC::Models::Channel.is_valid?(" channel") == false    
    assert IRC::Models::Channel.is_valid?("channel") == false    
  end
  
  def test_add_user(channel_name = "#ircguerilla", nick = "ircguerilla")
    user = @network.create_user(nick)
    channel = @network.create_channel(channel_name)
    channel.add_user(user)
    assert channel.users.include?(user)
  end
  
  def test_remove_channel(channel_name = "#ircguerilla", nick = "ircguerilla")
    test_add_user(channel_name, nick)
    user = @network.lookup_user(nick)
    channel = @network.lookup_channel(channel_name)
    channel.remove_user(user)
    assert !channel.users.include?(user)
  end
  
end
