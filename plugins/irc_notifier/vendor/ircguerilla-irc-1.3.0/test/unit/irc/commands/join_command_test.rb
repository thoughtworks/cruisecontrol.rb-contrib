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
# $Id: join_command_test.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/commands/command_test'
require 'irc/commands/join_command'
require 'irc/messages/join_message'
require 'irc/models/network'
require 'test/unit'

class IRC::Commands::JoinCommandTest < IRC::Commands::CommandTest

  def test_command_with_name
    assert_equal "JOIN #ircguerilla", IRC::Commands::JoinCommand.new("#ircguerilla").command
  end
  
  def test_command_with_names
    assert_equal "JOIN #ircguerilla,#mp3", IRC::Commands::JoinCommand.new(["#ircguerilla", "#mp3"]).command
  end
  
  def test_command_with_channel
    channel = IRC::Models::Network.new(:name => "Efnet").create_channel("#ircguerilla")
    assert_equal "JOIN #ircguerilla", IRC::Commands::JoinCommand.new(channel).command
  end
  
  def test_command_with_channels
    channels = Array.new
    channels << IRC::Models::Network.new(:name => "Efnet").create_channel("#ircguerilla")  
    channels << IRC::Models::Network.new(:name => "Efnet").create_channel("#mp3")      
    assert_equal "JOIN #ircguerilla,#mp3", IRC::Commands::JoinCommand.new(channels).command
  end
  
  def test_command_with_name_and_password
    assert_equal "JOIN #ircguerilla secret", IRC::Commands::JoinCommand.new("#ircguerilla", "secret").command
  end
  
  def test_command_with_names_and_passwords
    assert_equal "JOIN #ircguerilla,#mp3 secret1,secret2", IRC::Commands::JoinCommand.new(["#ircguerilla", "#mp3"], ["secret1", "secret2"]).command
  end
  
  def test_command_with_channel_and_password
    channel = IRC::Models::Network.new(:name => "Efnet").create_channel("#ircguerilla")
    assert_equal "JOIN #ircguerilla secret", IRC::Commands::JoinCommand.new(channel, "secret").command
  end
  
  def test_command_with_channels_and_passwords
    channels = Array.new
    channels << IRC::Models::Network.new(:name => "Efnet").create_channel("#ircguerilla")  
    channels << IRC::Models::Network.new(:name => "Efnet").create_channel("#mp3")      
    assert_equal "JOIN #ircguerilla,#mp3 secret1,secret2", IRC::Commands::JoinCommand.new(channels, ["secret1", "secret2"]).command
  end
  
end