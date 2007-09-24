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
require 'irc/client/connection'
require 'irc/client/connection_listener'
require 'irc/client/context'
require 'irc/commands/command'
require 'irc/messages/message'
require 'irc/messages/nick_message'
require 'irc/models/network'
require 'timeout'
require 'test/unit'
require File.dirname(__FILE__) + '/../../../test_helper'

class IRC::Commands::CommandTest < Test::Unit::TestCase

  include IRC::Client::ConnectionListener
  
  attr_reader :connection
  attr_reader :server
    
  def setup
    
    # The connection mock & the server.
    @connection = IRC::Client::Connection.new
    @server = IRC::Models::Network.new(:name => "Efnet").create_server("irc.efnet.pl")
    
  end
  
  def test_command
    command = IRC::Commands::Command.new("NICK Wiz")
    assert_equal "NICK Wiz", command.command
  end
  
  def test_to_s
    command = IRC::Commands::Command.new("NICK Wiz")
    assert_equal "NICK Wiz", command.to_s
  end
  
  def test_valid_response
    command = IRC::Commands::Command.new("NICK Wiz")
    assert command.valid_response?(IRC::Messages::Message.new(":WiZ NICK Kilroy"))
  end
  
#  def test_on_server_response
#  
#    # Simulate a connection.
#    connection.connect(server)
#    
#    # Register the response message.
#    message = IRC::Messages::Message.new(":WiZ NICK Kilroy")
#    connection.register_raw_message(message.to_s)
#
#    command = IRC::Commands::Command.new("NICK Wiz")    
#    command.execute(connection)
#    
#    sleep 1
#
#    assert_equal message, command.response
#    
#  end
  

#  
#  def test_execute
#    
#    # Construct and execute the nick message.
#    command = IRC::Commands::Command.new("NICK Wiz")
#    command.execute(connection)
#    
#    # The command should be registered as a connection listener.
#    assert connection.connection_listeners.include?(command)
#    
#    # Send the response message.
#    command.on_server_response(connection, IRC::Messages::NickMessage.new(":WiZ NICK Kilroy"))
#
#    # Should return immediately.
#    command.wait
#
#    # The command should no longer be registered as a connection listener.
#    assert !connection.connection_listeners.include?(command)
#  
#  end
#
#  def test_to_s
#    command = IRC::Commands::Command.new("NICK Wiz")
#    assert_equal "NICK Wiz", command.to_s
#  end  
#  
#  def test_wait
#    
#    # Construct and execute the nick message.
#    command = IRC::Commands::Command.new("NICK Wiz")
#    command.execute(connection)
#        
#    # The command should be registered as a connection listener.
#    assert connection.connection_listeners.include?(command)
#    
#    # The wait method should block until a response was received. Because the VALID response
#    # hasn't been received yet this method should block forever. 
#    assert_raise(Timeout::Error) do
#      Timeout::timeout(0.1) { command.wait }
#    end
#    
#    # Send the response message.
#    command.on_server_response(connection, IRC::Messages::NickMessage.new(":WiZ NICK Kilroy"))
#    
#    # Now the methos shouldn't block anymore.
#    Timeout::timeout(0.1) do
#      command.wait 
#    end
#
#    # The command should no longer be registered as a connection listener.
#    assert !connection.connection_listeners.include?(command)
#  
#  end
  
end