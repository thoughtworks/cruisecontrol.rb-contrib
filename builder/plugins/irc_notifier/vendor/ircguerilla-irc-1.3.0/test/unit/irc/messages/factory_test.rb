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
# $Id: factory_test.rb 90 2006-08-13 14:45:04Z roman $
# 
require 'irc/messages/factory'
require 'test/unit'

class IRC::Messages::FactoryTest < Test::Unit::TestCase

  def test_error_message
    message = IRC::Messages::Factory.create("ERROR :Closing Link: 85.178.111.249 (*** Banned (cache))")
    assert message.instance_of?(IRC::Messages::ErrorMessage)
  end

  def test_error_nick_name_in_use_message
    message = IRC::Messages::Factory.create(":irc.easynews.com 433 * fumanshu :Nickname is already in use.")
    assert message.instance_of?(IRC::Messages::ErrorNickNameInUseMessage)
  end
  
  def test_isupport_message
    message = IRC::Messages::ISupportMessage.new(":irc.efnet.pl 005 fumanshu STD=i-d STATUSMSG=@+ KNOCK EXCEPTS INVEX MODES=4 MAXCHANNELS=25 MAXBANS=100 MAXTARGET S=4 NICKLEN=9 TOPICLEN=120 KICKLEN=120 :are supported by this server")  
    assert message.instance_of?(IRC::Messages::ISupportMessage)
  end

  def test_join_message
    message = IRC::Messages::Factory.create(":WiZ JOIN #Twilight_zone")
    assert message.instance_of?(IRC::Messages::JoinMessage)
  end
  
  def test_kick_message
    message = IRC::Messages::Factory.create(":WiZ KICK #Finnish John")
    assert message.instance_of?(IRC::Messages::KickMessage)
  end

  def test_nick_message
    message = IRC::Messages::Factory.create(":WiZ NICK Kilroy")
    assert message.instance_of?(IRC::Messages::NickMessage)
  end

  def test_notice_message
    message = IRC::Messages::Factory.create("NOTICE AUTH :*** Looking up your hostname...")
    assert message.instance_of?(IRC::Messages::NoticeMessage)
  end
  
  def test_part_message
    message = IRC::Messages::Factory.create(":WiZ PART #Twilight_zone")
    assert message.instance_of?(IRC::Messages::PartMessage)
  end
  
  def test_ping_message
    message = IRC::Messages::Factory.create("PING tolsun.oulu.fi")
    assert message.instance_of?(IRC::Messages::PingMessage)
  end

  def test_pong_message
    message = IRC::Messages::Factory.create("PONG tolsun.oulu.fi")
    assert message.instance_of?(IRC::Messages::PongMessage)
  end

  def test_private_message
    message = IRC::Messages::Factory.create(":Angel PRIVMSG Wiz :Hello are you receiving this message ?")
    assert message.instance_of?(IRC::Messages::PrivateMessage)
  end

  def test_welcome_message
    message = IRC::Messages::Factory.create(":irc.easynews.com 001 fumanshu :Welcome to the EFNet IRC via Easynews fumanshu")
    assert message.instance_of?(IRC::Messages::WelcomeMessage)
  end
  
end