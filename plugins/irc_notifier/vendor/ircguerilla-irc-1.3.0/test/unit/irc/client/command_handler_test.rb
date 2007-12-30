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
require 'irc/client/command_handler'
require 'irc/client/context'
require 'irc/commands/nick_command'
require 'irc/commands/password_command'
require 'irc/models/network'
require 'stringio'
require 'test/unit'

class IRC::Client::CommandHandlerTest < Test::Unit::TestCase

  def setup
  
    # Set up a connection context.
    @context = IRC::Client::Connection::Context.new
    @context.network = IRC::Models::Network.new(:name => "Efnet")
    @context.output_socket = StringIO.new("", "w+")

    # Initialize the command handler with the mock connection context.
    @command_handler = IRC::Client::CommandHandler.new(@context)
    @command_handler.delay = 0.1
    
  end

  def test_start
  
    # Start the command handler.
    @command_handler.start
    
    # Starting the command handler again should raise an exception.
    assert_raise(IRC::Client::CommandHandlerError) { @command_handler.start }
    
    # Stop the command handler.
    @command_handler.stop    
    
  end

  def test_stop
  
    # Stopping a not started command handler should raise an exception.
    assert_raise(IRC::Client::CommandHandlerError) { @command_handler.stop }
    
    # Stopping a command handler after it was started should work fine.
    @command_handler.start
    @command_handler.stop        
    
  end
  
  def test_send_command
  
    # Start the command handler.
    @command_handler.start

    # Send the password command.
    password_command = IRC::Commands::PasswordCommand.new("secret")      
    @command_handler.send_command(password_command)

    # Send the nick command.
    nick_command = IRC::Commands::NickCommand.new("fumanshu")
    @command_handler.send_command(nick_command)

    # Rewind the stringio object, so we can read from it.
    @context.output_socket.rewind
    
    # Both commands should be available immediately, since they were not sent through the queue.
    assert_equal password_command.command, @context.output_socket.readline.chomp
    assert_equal nick_command.command, @context.output_socket.readline.chomp    
    
    # There should be no more commands available.
    assert_raise(EOFError) { @context.output_socket.readline }    

    # Stop the command handler.
    @command_handler.stop        
    
  end
  
  def test_send_command_via_queue
  
    # Start the command handler.
    @command_handler.start

    # Send the password command.
    password_command = IRC::Commands::PasswordCommand.new("secret")      
    @command_handler.send_command_via_queue(password_command)
    
    # Send the nick command.
    nick_command = IRC::Commands::NickCommand.new("fumanshu")
    @command_handler << nick_command
    
    # Rewind the stringio object, so we can read from it.
    @context.output_socket.rewind

    # The first command got sent but the second is still in the queue.
    assert_equal password_command.command, @context.output_socket.readline.chomp
    assert_raise(EOFError) { @context.output_socket.readline }

    # Wait for the 2nd command.
    sleep @command_handler.delay * 1.5

    # Rewind again and start reading all commands from scratch.
    @context.output_socket.rewind
    assert_equal password_command.command, @context.output_socket.readline.chomp
    assert_equal nick_command.command, @context.output_socket.readline.chomp    
    
    # There should be no more commands available.
    assert_raise(EOFError) { @context.output_socket.readline }

    # Stop the command handler.
    @command_handler.stop        
  
  end
  
end