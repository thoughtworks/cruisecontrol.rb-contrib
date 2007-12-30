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
require 'irc/util/color'
require 'test/unit'
require File.dirname(__FILE__) + '/../../../test_helper'

class IRC::Util::ColorTest < Test::Unit::TestCase

  def setup
  end

  def test_remove_color
    
    message_clean = "red blue"
    message_dirty = IRC::Util::Color::RED + "red " + IRC::Util::Color::BLUE + "blue"
    assert_equal message_clean, IRC::Util::Color.remove_color(message_dirty)
    
    message_clean = "white blue black"
    message_dirty = IRC::Util::Color::WHITE + "white " + IRC::Util::Color::MAGENTA + "blue " + IRC::Util::Color::BLACK + "black"  
    assert_equal message_clean, IRC::Util::Color.remove_color(message_dirty)
    
  end
  
  def test_remove_formatting

    message_clean = "bold normal"    
    message_dirty = "bold normal"
    assert_equal message_clean, IRC::Util::Color.remove_formatting(message_dirty)

    message_clean = "normal bold underline reverse normal"    
    message_dirty = IRC::Util::Color::NORMAL + "normal " + IRC::Util::Color::BOLD + "bold " + 
                    IRC::Util::Color::UNDERLINE + "underline " + IRC::Util::Color::REVERSE + 
                    "reverse " + IRC::Util::Color::NORMAL + "normal"

    assert_equal message_clean, IRC::Util::Color.remove_formatting(message_dirty)
    
  end
  
  def test_remove_color_and_formatting

    message_clean = "bold normal red underline normal"    
    message_dirty = IRC::Util::Color::BOLD + "bold " + IRC::Util::Color::NORMAL + "normal " +
                    IRC::Util::Color::RED + "red " + IRC::Util::Color::UNDERLINE + "underline " +
                    IRC::Util::Color::NORMAL + "normal"
    assert_equal message_clean, IRC::Util::Color.remove_color_and_formatting(message_dirty)
    
  end
  
  def test_remove_color_and_formatting_with_mirc_example
  
    message_clean = "blabla to be colored text and background blabla" 
    message_dirty = "blabla \x035,12to be colored text and background\x03 blabla"
    assert_equal message_clean, IRC::Util::Color.remove_color_and_formatting(message_dirty)
    
    message_clean = "blabla to be colored text blabla"
    message_dirty = "blabla \x035to be colored text\x03 blabla"
    assert_equal message_clean, IRC::Util::Color.remove_color_and_formatting(message_dirty)
  
    message_clean = "blabla to be colored text other colored text and also background blabla"
    message_dirty = "blabla \x033to be colored text \x035,2other colored text and also background\x03 blabla"
    assert_equal message_clean, IRC::Util::Color.remove_color_and_formatting(message_dirty)

    message_clean = "blabla to be colored text and background other colored text but SAME background blabla"
    message_dirty = "blabla \x033,5to be colored text and background \x038other colored text but SAME background\x03 blabla"
    assert_equal message_clean, IRC::Util::Color.remove_color_and_formatting(message_dirty)

    message_clean = "blabla to be colored text and background other colored text and other background blabla"
    message_dirty = "blabla \x033,5to be colored text and background \x038,7other colored text and other background\x03 blabla"
    assert_equal message_clean, IRC::Util::Color.remove_color_and_formatting(message_dirty)
    
  end
  
  
end
