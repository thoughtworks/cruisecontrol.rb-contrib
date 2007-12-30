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
# $Id: server_test.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/models/channel'
require 'irc/models/network'
require 'irc/models/server'
require 'irc/models/user'
require 'test/unit'

class IRC::Models::ServerTest < Test::Unit::TestCase

  def setup
    @network = IRC::Models::Network.new(:name => 'Efnet')
  end
  
  def test_key
    network = IRC::Models::Network.new(:name => 'Efnet')
    server = network.create_server('irc.EfNet.pl', 6667)
    assert_equal 'efnet|irc.efnet.pl|6667', server.key
  end

  def test_equal

    assert_equal @network.create_server('irc.efnet.pl'), @network.create_server('irc.efnet.pl')

    assert_not_equal @network.create_server('irc.efnet.pl'), @network.create_server('irc.efnet.de')        
    assert_not_equal @network.create_server('irc.efnet.pl', 6668), @network.create_server('irc.efnet.pl', 6669)    
    assert_not_equal IRC::Models::Server.new(:network => IRC::Models::Network.new(:name => 'Undernet'), :hostname => 'irc.efnet.pl'), IRC::Models::Server.new(:network => @network, :hostname => 'irc.efnet.pl')
        
  end

end
