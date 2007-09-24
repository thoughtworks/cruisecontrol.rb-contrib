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
# $Id: ping_command_test.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/commands/command_test'
require 'irc/commands/ping_command'
require 'irc/messages/pong_message'
require 'test/unit'

class IRC::Commands::PingCommandTest < IRC::Commands::CommandTest

  def test_command
    assert_equal "PING WiZ", IRC::Commands::PingCommand.new("WiZ").command
    assert_equal "PING WiZ irc.efnet.pl", IRC::Commands::PingCommand.new("WiZ", "irc.efnet.pl").command    
  end
  
  def test_execute
  
    # Simulate a connection.
    connection.connect(server)
    
    # Construct and execute the nick message.
    command = IRC::Commands::PingCommand.new("tolsun.oulu.fi")
    command.execute(connection)
    
    # The command should be registered as a connection listener.
    assert connection.connection_listeners.include?(command)
    
    # Send the response message.
    command.on_server_response(connection, IRC::Messages::PongMessage.new("PONG tolsun.oulu.fi"))

    # Should return immediately.
    command.wait
    
    # The command should no longer be registered as a connection listener.
    assert !connection.connection_listeners.include?(command)
  
  end

  def test_to_s
    command = IRC::Commands::PingCommand.new("WiZ")
    assert_equal "PING WiZ", command.to_s
  end  
  
  def test_wait_for_pong
  
    # Simulate a connection.
    connection.connect(server)
    
    # Construct and execute the nick message.
    command = IRC::Commands::PingCommand.new("tolsun.oulu.fi")
    command.execute(connection)
    
    # The command should be registered as a connection listener.
    assert connection.connection_listeners.include?(command)
    
    # The wait method should block until a response was received. Because the VALID response
    # hasn't been received yet this method should block forever. 
    assert_raise(Timeout::Error) do
      command.on_server_response(connection, IRC::Messages::NickMessage.new(":WiZ NICK Kilroy"))
      Timeout::timeout(0.1) { command.wait }
    end
    
    # Send the response message.
    command.on_server_response(connection, IRC::Messages::PongMessage.new("PONG tolsun.oulu.fi"))
    
    # Now the methos shouldn't block anymore.
    Timeout::timeout(0.1) do
      command.wait 
    end

    # The command should no longer be registered as a connection listener.
    assert !connection.connection_listeners.include?(command)
  
  end  
  
  def test_wait_for_error_no_origin
  
    # Simulate a connection.
    connection.connect(server)
  
    # Construct and execute the nick message.
    command = IRC::Commands::PingCommand.new("tolsun.oulu.fi")
    command.execute(connection)
    
    # The command should be registered as a connection listener.
    assert connection.connection_listeners.include?(command)
    
    # The wait method should block until a response was received. Because the VALID response
    # hasn't been received yet this method should block forever. 
    assert_raise(Timeout::Error) do
      command.on_server_response(connection, IRC::Messages::Message.new(":irc.easynews.com 4XX"))
      Timeout::timeout(0.1) { command.wait }
    end
    
    # Send the response message.
    command.on_server_response(connection, IRC::Messages::ErrorNoOriginMessage.new(":irc.easynews.com 4XX"))
    
    # Now the methos shouldn't block anymore.
    Timeout::timeout(0.1) do
      command.wait 
    end

    # The command should no longer be registered as a connection listener.
    assert !connection.connection_listeners.include?(command)
  
  end  
  
  def test_wait_for_error_no_such_server

    # Simulate a connection.
    connection.connect(server)
    
    # Construct and execute the nick message.
    command = IRC::Commands::PingCommand.new("tolsun.oulu.fi")
    command.execute(connection)
    
    # The command should be registered as a connection listener.
    assert connection.connection_listeners.include?(command)
    
    # The wait method should block until a response was received. Because the VALID response
    # hasn't been received yet this method should block forever. 
    assert_raise(Timeout::Error) do
      command.on_server_response(connection, IRC::Messages::Message.new(":irc.easynews.com 4XX"))
      Timeout::timeout(0.1) { command.wait }
    end
    
    # Send the response message.
    command.on_server_response(connection, IRC::Messages::ErrorNoSuchServerMessage.new(":irc.easynews.com 4XX"))
    
    # Now the methos shouldn't block anymore.
    Timeout::timeout(0.1) do
      command.wait 
    end

    # The command should no longer be registered as a connection listener.
    assert !connection.connection_listeners.include?(command)
  
  end  
  
end