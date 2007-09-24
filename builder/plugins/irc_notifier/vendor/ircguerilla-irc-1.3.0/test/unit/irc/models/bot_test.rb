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
# $Id: bot_test.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/models/bot'
require 'irc/models/network'
require 'test/unit'

class IRC::Models::BotTest < Test::Unit::TestCase

  def setup
    network = IRC::Models::Network.new(:name => 'Efnet')
    @bot = network.create_bot('dr-fumanshu')
  end

  def test_create_packet
  
    packet = @bot.create_packet(1, "Mary_J_Blige-My_Collection_Of_Love_Songs-2006-CNS.tar", 1024 * 10, 10)
    assert_equal 1, @bot.packets.size
    assert_equal 1, packet.number
    assert_equal "Mary_J_Blige-My_Collection_Of_Love_Songs-2006-CNS.tar", packet.description
    assert_equal 1024 * 10, packet.size_in_bytes
    assert_equal 10, packet.number_of_downloads
    
    packet = @bot.create_packet(2, "The_Bee_Gees-Love_Songs-CD-2005-OMC.tar", 1024 * 20, 20)
    assert_equal 2, @bot.packets.size
    assert_equal 2, packet.number
    assert_equal "The_Bee_Gees-Love_Songs-CD-2005-OMC.tar", packet.description
    assert_equal 1024 * 20, packet.size_in_bytes
    assert_equal 20, packet.number_of_downloads
    
    assert_raise(Exception) { @bot.create_packet(2, "50_Cent_f_Nate_Dogg-21_Questions-SVCD-2003-Ice01-UVZ.m2v", 1024 * 20, 20) }
    
  end
  
  def test_packet
  
    packet = @bot.create_packet(2, "Mary_J_Blige-My_Collection_Of_Love_Songs-2006-CNS.tar", 1024 * 20, 20)
    assert_equal 1, @bot.packets.size
    
    # First packet doesn't exist.
    assert_nil @bot.packet(1)
    
    assert_equal packet, @bot.packet(2)
    assert_equal 2, packet.number
    assert_equal "Mary_J_Blige-My_Collection_Of_Love_Songs-2006-CNS.tar", packet.description
    assert_equal 1024 * 20, packet.size_in_bytes
    assert_equal 20, packet.number_of_downloads
  
  end
    
  def test_packets
    
    @bot.create_packet(1, "Mary_J_Blige-My_Collection_Of_Love_Songs-2006-CNS.tar", 1024 * 10, 10)
    assert @bot.packets.include?(@bot.packet(1))
    
    @bot.create_packet(3, "The_Bee_Gees-Love_Songs-CD-2005-OMC.tar", 1024 * 30, 30)    
    assert @bot.packets.include?(@bot.packet(3))
    
    assert_equal 2, @bot.packets.size
  
  end
  
end
