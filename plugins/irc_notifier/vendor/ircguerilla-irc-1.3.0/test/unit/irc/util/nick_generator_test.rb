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
require 'irc/util/nick_generator'
require 'test/unit'
require File.dirname(__FILE__) + '/../../../test_helper'

class IRC::Util::NickGeneratorTest < Test::Unit::TestCase

  def test_names
    generator = IRC::Util::NickGenerator.new("fumanshu")
    assert_equal %w(fumanshu1 fumanshu2 fumanshu3 fumanshu4 fumanshu5 fumanshu6 fumanshu7 fumanshu8 fumanshu9 fumanshu10), generator.names
  end

  def test_names_with_nick_length

    generator = IRC::Util::NickGenerator.new("fumanshu", 9)
    assert_equal %w(fumanshu1 fumanshu2 fumanshu3 fumanshu4 fumanshu5 fumanshu6 fumanshu7 fumanshu8 fumanshu9 fumansh10), generator.names

    generator = IRC::Util::NickGenerator.new("fumanshu", 8)
    assert_equal %w(fumansh1 fumansh2 fumansh3 fumansh4 fumansh5 fumansh6 fumansh7 fumansh8 fumansh9 fumans10), generator.names

  end
  
  def test_names_with_max_nicks
    generator = IRC::Util::NickGenerator.new("fumanshu", nil, 3)
    assert_equal %w(fumanshu1 fumanshu2 fumanshu3), generator.names
  end
  
end
