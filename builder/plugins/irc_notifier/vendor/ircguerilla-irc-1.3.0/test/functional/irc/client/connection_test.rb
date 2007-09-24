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
require 'stringio'
require 'irc/client/connection'
require 'irc/client/disconnected_state'
require 'irc/models/network'
require 'test/unit'
require 'timeout'

require File.dirname(__FILE__) + '/../../../test_helper'

@response = StringIO.new


class IRC::Client::ConnectionTest < Test::Unit::TestCase
  
  def setup
    
    # Initialize the network, channel & server that is used for testing.
    network = IRC::Models::Network.new(:name => "Efnet")
    @channel = network.create_channel("#MP3_RAP_N_REGGAE")
    @server = network.create_server("irc.efnet.pl")
    
    # Initialize the connection connection.
    @connection = IRC::Client::Connection.new("fumanshu")
    
  end
  
  def test_connect
    
    # The connection shouldn't be connected now.
    assert !@connection.connected?
    
    # Connect to the server and wait until the connection is in the unregistered state.
    Timeout::timeout(IRC::Client::Connection::MAX_CONNECTION_TIMEOUT_IN_SEC) do
      @connection.connect(@server)    
      while !@connection.connected? do sleep 0.1; end
    end
    
    # Wait until the connection is registered.
    Timeout::timeout(5) do
      @connection.register
      while !@connection.registered? do sleep 0.1; end
    end
    
    # Disconnect and wait until the connection is in the disconnected state.
    Timeout::timeout(5) do
      @connection.disconnect
      while @connection.connected? do sleep 0.1; end      
    end
    
  end
  
  def test_nick_change
  
    # The connection shouldn't be connected now.
    assert !@connection.connected?
    
    # Connect to the server and wait until the connection is in the unregistered state.
    Timeout::timeout(IRC::Client::Connection::MAX_CONNECTION_TIMEOUT_IN_SEC) do
      @connection.connect(@server)    
      while !@connection.connected? do sleep 0.1; end
    end
    
    # Wait until the connection is registered.
    Timeout::timeout(5) do
      @connection.register
      while !@connection.registered? do sleep 0.1; end
    end
    
    # Try to change the nick name & wait until changed.
    Timeout::timeout(5) do
      @connection.nick = "N1CKCHANGE"
      while @connection.nick != "N1CKCHANGE"[0..@connection.nick.size-1] do sleep 0.1; end      
    end    
    
    # Disconnect and wait until the connection is in the disconnected state.
    Timeout::timeout(5) do
      @connection.disconnect
      while @connection.connected? do sleep 0.1; end      
    end
  
  end
  
  def test_join_and_part
    
    # The connection shouldn't be connected now.
    assert !@connection.connected?
    
    # Connect to the server and wait until the connection is in the unregistered state.
    Timeout::timeout(IRC::Client::Connection::MAX_CONNECTION_TIMEOUT_IN_SEC) do
      @connection.connect(@server)    
      while !@connection.connected? do sleep 0.1; end
    end
    
    # Wait until the connection is registered.
    Timeout::timeout(5) do
      @connection.register
      while !@connection.registered? do sleep 0.1; end
    end
    
    # Join a channel & wait until the channel is joined and the block was called.
    Timeout::timeout(5) do
      @connection.join(@channel)
      while !@connection.joined?(@channel) do sleep 0.1 end
    end    
    
    # Leave the joined channel.
    Timeout::timeout(5) do
      @connection.part(@channel)
      while @connection.joined?(@channel) do sleep 0.1 end
    end    
    
    # Disconnect and wait until the connection is in the disconnected state.
    Timeout::timeout(5) do
      @connection.disconnect
      while @connection.connected? do sleep 0.1; end      
    end
  
  end  
  
end