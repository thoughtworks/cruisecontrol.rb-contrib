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
# $Id: network_test.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/models/bot'
require 'irc/models/channel'
require 'irc/models/network'
require 'irc/models/server'
require 'irc/models/user'
require 'test/unit'

class IRC::Models::NetworkTest < Test::Unit::TestCase

  def test_equal
    assert_equal IRC::Models::Network.new(:name => 'Efnet'), IRC::Models::Network.new(:name => 'Efnet')
    assert_not_equal IRC::Models::Network.new(:name => 'Efnet'), IRC::Models::Network.new(:name => 'Undernet')  
  end
  
  def test_key
    network = IRC::Models::Network.new(:name => 'Efnet')
    assert_equal 'efnet', network.key
  end
  
  def test_lookup_or_create_bot

    # Create the network.  
    network = IRC::Models::Network.new(:name => 'Efnet')

    # Create a new bot.
    bot = network.lookup_or_create_bot('dr-fumanshu')
    assert_not_nil bot
    assert_equal network, bot.network
    assert_equal 1, network.bots.size
    assert_equal 1, network.users.size    
    
    # Create the same bot again should return the previously
    # created bot.
    same_bot = network.lookup_or_create_bot('dr-fumanshu')
    assert_equal 1, network.bots.size
    assert_equal 1, network.users.size
    assert_equal bot, same_bot
    
    # Create an other bot.
    other_user = network.lookup_or_create_bot('badman')
    assert_equal 2, network.bots.size
    assert_equal 2, network.users.size    

  end    
    
  def test_lookup_or_create_channel

    # Create the network.  
    network = IRC::Models::Network.new(:name => 'Efnet')

    # Create a new channel.
    channel = network.lookup_or_create_channel('#channel')
    assert_not_nil channel
    assert_equal(network, channel.network)    
    assert_equal(1, network.channels.size)
    
    # Create the same channel again should return the previously
    # created channel.
    same_channel = network.lookup_or_create_channel('#channel')
    assert_equal(1, network.channels.size)
    assert_equal(channel, same_channel)
    
    # Create an other channel.
    other_channel = network.lookup_or_create_channel('#other')
    assert_equal(2, network.channels.size)

  end
    
  def test_lookup_or_create_server

    # Create the network.  
    network = IRC::Models::Network.new(:name => 'Efnet')

    # Create a new server.
    server = network.lookup_or_create_server('irc.efnet.de')
    assert_not_nil server
    assert_equal(network, server.network)        
    assert_equal(1, network.servers.size)
    
    # Create the same server again should return the previously
    # created server.
    same_server = network.lookup_or_create_server('irc.efnet.de')
    assert_equal(1, network.servers.size)
    assert_equal(server, same_server)
    
    # Create an other server.
    other_server = network.lookup_or_create_server('irc.efnet.com')
    assert_equal(2, network.servers.size)

  end
    
  def test_lookup_or_create_user

    # Create the network.  
    network = IRC::Models::Network.new(:name => 'Efnet')

    # Create a new user.
    user = network.lookup_or_create_user('dr-fumanshu')
    assert_not_nil user
    assert_equal(network, user.network)        
    assert_equal(1, network.users.size)
    
    # Create the same user again should return the previously
    # created user.
    same_user = network.lookup_or_create_user('dr-fumanshu')
    assert_equal(1, network.users.size)
    assert_equal(user, same_user)
    
    # Create an other user.
    other_user = network.lookup_or_create_user('badman')
    assert_equal(2, network.users.size)

  end  
    
  def test_lookup_bot
  
    # Create the network.  
    network = IRC::Models::Network.new(:name => 'Efnet')

    # Create and lookup bot.
    bot = network.create_bot('batman')
    assert_equal bot, network.lookup_bot(bot.nick)
    assert_equal 1, network.bots.size
    assert_equal 1, network.users.size    

    # Create user and lookup bot with the user's name.
    user = network.create_user('dr-fumanshu')
    assert_equal 1, network.bots.size
    assert_equal 2, network.users.size
    
    assert_nil network.lookup_bot('dr-fumanshu')
  
  end  
    
  def test_lookup_channel
  
    # Create the network.  
    network = IRC::Models::Network.new(:name => 'Efnet')

    # Create and lookup channel.
    channel = network.create_channel('#channel')
    assert_equal channel, network.lookup_channel('#channel')
  
  end
  
  def test_lookup_server
  
    # Create the network.  
    network = IRC::Models::Network.new(:name => 'Efnet')

    # Create and lookup server.
    server = network.create_server('irc.efnet.de', 23)
    assert_equal server, network.lookup_server('irc.efnet.de', 23)
  
  end
  
  def test_lookup_user
  
    # Create the network.  
    network = IRC::Models::Network.new(:name => 'Efnet')

    # Create and lookup user.
    user = network.create_user('dr-fumanshu')
    assert_not_nil user
    assert_equal 1, network.users.size
    assert_equal 0, network.bots.size    
    assert_equal user, network.lookup_user(user.nick)
    
    # Create a bot and lookup bot as user.
    bot = network.create_bot('batman')
    assert_not_nil bot
    assert_equal 2, network.users.size
    assert_equal 1, network.bots.size    
    
    assert_equal bot, network.lookup_user(bot.nick)
  
  end
  
  def test_to_xml
    network = IRC::Models::Network.new(:name => 'Efnet')
    network.create_channel("#ircguerilla", "secret")
    network.create_server("irc.efnet.pl")
  end
  
end
