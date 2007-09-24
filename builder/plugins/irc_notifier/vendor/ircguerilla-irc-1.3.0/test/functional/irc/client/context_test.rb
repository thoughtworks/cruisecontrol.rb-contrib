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
# $Id: context_test.rb 94 2006-08-13 21:40:40Z roman $
# 
require 'stringio'
require 'irc/client/context'
require 'irc/client/disconnected_state'
require 'irc/models/network'
require 'test/unit'
require 'timeout'

require File.dirname(__FILE__) + '/../../../test_helper'

@response = StringIO.new


class IRC::Client::ContextTest < Test::Unit::TestCase
  
  def setup

    # Initialize the network, channel & server that is used for testing.
    network = IRC::Models::Network.new(:name => "Efnet")
    @channel = network.create_channel("#ircguerilla")
    @server = network.create_server("irc.efnet.pl")
    
    # Initialize the connection context.
    @context = IRC::Client::Connection::Context.new("fumanshu")
  
  end

  def test_connect
          
    # The context should be in the disconnected state.
    assert @context.state.instance_of?(IRC::Client::DisconnectedState)
    
    # The context shouldn't be connected now.
    assert !@context.connected?

    # Connect to the server and wait until the context is in the unregistered state.
    Timeout::timeout(IRC::Client::Connection::MAX_CONNECTION_TIMEOUT_IN_SEC) do
      @context.connect(@server)    
      while !@context.connected? do sleep 0.1; end
    end
    
    # The context should be connected now.
    assert @context.connected?

    # Wait until the connection is registered.
    Timeout::timeout(5) do
      @context.register    
      while !@context.registered? do sleep 0.1; end
    end

    # Disconnect and wait until the context is in the disconnected state.
    Timeout::timeout(5) do
      @context.disconnect
      while @context.connected? do sleep 0.1; end
    end

  end
  
  def test_join_and_part
          
    # The context should be in the disconnected state.
    assert @context.state.instance_of?(IRC::Client::DisconnectedState)

    # Connect to the server and wait until the context is in the unregistered state.
    Timeout::timeout(IRC::Client::Connection::MAX_CONNECTION_TIMEOUT_IN_SEC) do
      @context.connect(@server)    
      while !@context.connected? do sleep 0.1; end
    end

    # Wait until the connection is registered.
    Timeout::timeout(5) do
      @context.register    
      while !@context.registered? do sleep 0.1; end
    end
    
    # Join a channel & wait until the channel is joined and the block was called.
    Timeout::timeout(5) do
      @context.join(@channel)
      while !@context.joined?(@channel) do sleep 0.1 end
    end    
    
    # Leave the joined channel.
    Timeout::timeout(5) do
      @context.part(@channel)
      while @context.joined?(@channel) do sleep 0.1 end
    end    

    # Disconnect and wait until the context is in the disconnected state.
    Timeout::timeout(5) do
      @context.disconnect
      while @context.connected? do sleep 0.1; end
    end

  end
  
  def test_truth
  end  
  
end