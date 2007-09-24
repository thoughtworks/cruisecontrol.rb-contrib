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
# $Id: message_test.rb 93 2006-08-13 21:30:53Z roman $
# 
require 'irc/client/connection'
require 'irc/client/connection_listener'
require 'irc/client/context'
require 'irc/messages/message'
require 'irc/models/network'
require 'irc/messages/message'
require 'test/unit'
require File.dirname(__FILE__) + '/../../../test_helper'

class IRC::Messages::MessageTest < Test::Unit::TestCase

  include IRC::Client::ConnectionListener
 
  attr_reader :connection
  attr_reader :server
    
  def setup
    
    # The connection mock & the server.
    @connection = IRC::Client::Connection.new
    @server = IRC::Models::Network.new(:name => "Efnet").create_server("irc.efnet.pl")
    
  end
  
  def test_eql
    
    message1 = IRC::Messages::Message.new(":WiZ JOIN #Twilight_zone")  
    message2 = IRC::Messages::Message.new(":WiZ JOIN #Twilight_zone")      
    
    assert_equal message1, message1
    assert_equal message1, message2    
    
    message3 = IRC::Messages::Message.new(":WiZ JOIN #ircguerilla")          
    assert_not_equal message1, message3
    assert_not_equal message2, message3    
    
  end

  def test_join_message
  
    message = IRC::Messages::JoinMessage.new(":WiZ JOIN #Twilight_zone")
    assert_equal "WiZ", message.nick
    assert_equal "WiZ", message.server    
    assert_equal "JOIN", message.code
    assert_equal "#Twilight_zone", message.message
  
    message = IRC::Messages::Message.new(":fumanshu!0NFOHVOw@e178069051.adsl.alicedsl.de JOIN :#ircguerilla")
    assert_equal "JOIN", message.code
    assert_nil message.server
    assert_equal "fumanshu", message.nick
    assert_equal "0NFOHVOw", message.login
    assert_equal "e178069051.adsl.alicedsl.de", message.host
    assert_equal ":#ircguerilla", message.message    
    
  end
  
  def test_welcome_message
    message = IRC::Messages::Message.new(":localhost.localdomain 001 drfumansh :Welcome to the Internet Relay Network, drfumansh")
    assert_equal 1, message.code
    assert_equal "localhost.localdomain", message.server    
    assert_equal "drfumansh :Welcome to the Internet Relay Network, drfumansh", message.message
  end
  
end