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
require 'irc/messages/invalid_message'
require 'irc/messages/isupport_message'
require 'irc/messages/message_test'
require 'test/unit'

class IRC::Messages::ISupportMessageTest < IRC::Messages::MessageTest
  
  def test_isupport

    # First isupport message.          
    message = IRC::Messages::ISupportMessage.new(":irc.efnet.pl 005 fumanshu STD=i-d STATUSMSG=@+ KNOCK EXCEPTS INVEX MODES=4 MAXCHANNELS=25 MAXBANS=100 MAXTARGET S=4 NICKLEN=9 TOPICLEN=120 KICKLEN=120 :are supported by this server")
    
    # Verify the standard message fields.
    assert_equal "irc.efnet.pl", message.server
    assert_equal 5, message.code    
    assert_equal "fumanshu", message.nick
    
    # Verify the supported options.
    assert_equal "i-d", message.options["STD"]
    assert_equal "@+", message.options["STATUSMSG"]
    assert message.options.has_key?("KNOCK")
    assert message.options.has_key?("EXCEPTS")
    assert message.options.has_key?("INVEX")    
    assert_equal 4, message.options["MODES"]    
    assert_equal 25, message.options["MAXCHANNELS"]        
    assert_equal 100, message.options["MAXBANS"]            
    assert_equal 4, message.options["S"]                
    assert_equal 9, message.options["NICKLEN"]
    assert_equal 120, message.options["TOPICLEN"]
    assert_equal 120, message.options["KICKLEN"]        
    
    # Second isupport message.    
    message = IRC::Messages::ISupportMessage.new(":irc.efnet.pl 005 fumanshu CHANTYPES=#& PREFIX=(ov)@+ CHANMODES=eIb,k,l,imnpst NETWORK=EFNet CASEMAPPING=rfc1459 CHARSET=ascii CALLERID ETRACE WALLCHOPS SAFELIST ELIST=U :are supported by this server")

    # Verify the standard message fields.
    assert_equal "irc.efnet.pl", message.server
    assert_equal 5, message.code    
    assert_equal "fumanshu", message.nick
    
    # Verify the supported options from the second message.    
    assert_equal "#&", message.options["CHANTYPES"]      
    assert_equal "(ov)@+", message.options["PREFIX"]          
    assert_equal "eIb,k,l,imnpst", message.options["CHANMODES"]
    assert_equal "EFNet", message.options["NETWORK"]     
    assert_equal "rfc1459", message.options["CASEMAPPING"]         
    assert_equal "ascii", message.options["CHARSET"] 
    assert message.options.has_key?("CALLERID")
    assert message.options.has_key?("ETRACE")
    assert message.options.has_key?("WALLCHOPS")
    assert message.options.has_key?("SAFELIST")
    assert_equal "U", message.options["ELIST"]             
    
  end
  
  def test_handle
  
    # Simulate a connection registration.
    connection.add_connection_listener(self)
    connection.connect(server)
    connection.register
      
    # First isupport message.          
    message = IRC::Messages::ISupportMessage.new(":irc.efnet.pl 005 fumanshu STD=i-d STATUSMSG=@+ KNOCK EXCEPTS INVEX MODES=4 MAXCHANNELS=25 MAXBANS=100 MAXTARGET S=4 NICKLEN=9 TOPICLEN=120 KICKLEN=120 :are supported by this server")
    message.handle(connection.context)
    
    # Verify the supported options.
    assert_equal "i-d", connection.context.options["STD"]
    assert_equal "@+", connection.context.options["STATUSMSG"]
    assert connection.context.options.has_key?("KNOCK")
    assert connection.context.options.has_key?("EXCEPTS")
    assert connection.context.options.has_key?("INVEX")    
    assert_equal 4, connection.context.options["MODES"]    
    assert_equal 25, connection.context.options["MAXCHANNELS"]        
    assert_equal 100, connection.context.options["MAXBANS"]            
    assert_equal 4, connection.context.options["S"]                
    assert_equal 9, connection.context.options["NICKLEN"]
    assert_equal 120, connection.context.options["TOPICLEN"]
    assert_equal 120, connection.context.options["KICKLEN"]       

    # Second isupport message.    
    message = IRC::Messages::ISupportMessage.new(":irc.efnet.pl 005 fumanshu CHANTYPES=#& PREFIX=(ov)@+ CHANMODES=eIb,k,l,imnpst NETWORK=EFNet CASEMAPPING=rfc1459 CHARSET=ascii CALLERID ETRACE WALLCHOPS SAFELIST ELIST=U :are supported by this server")
    message.handle(connection.context)
    
    # Verify the supported options from the first message.
    assert_equal "i-d", connection.context.options["STD"]
    assert_equal "@+", connection.context.options["STATUSMSG"]
    assert connection.context.options.has_key?("KNOCK")
    assert connection.context.options.has_key?("EXCEPTS")
    assert connection.context.options.has_key?("INVEX")    
    assert_equal 4, connection.context.options["MODES"]    
    assert_equal 25, connection.context.options["MAXCHANNELS"]        
    assert_equal 100, connection.context.options["MAXBANS"]            
    assert_equal 4, connection.context.options["S"]                
    assert_equal 9, connection.context.options["NICKLEN"]
    assert_equal 120, connection.context.options["TOPICLEN"]
    assert_equal 120, connection.context.options["KICKLEN"] 
    
    # Verify the supported options from the second message.    
    assert_equal "#&", connection.context.options["CHANTYPES"]      
    assert_equal "(ov)@+", connection.context.options["PREFIX"]          
    assert_equal "eIb,k,l,imnpst", connection.context.options["CHANMODES"]
    assert_equal "EFNet", connection.context.options["NETWORK"]     
    assert_equal "rfc1459", connection.context.options["CASEMAPPING"]         
    assert_equal "ascii", connection.context.options["CHARSET"] 
    assert connection.context.options.has_key?("CALLERID")
    assert connection.context.options.has_key?("ETRACE")
    assert connection.context.options.has_key?("WALLCHOPS")
    assert connection.context.options.has_key?("SAFELIST")
    assert_equal "U", connection.context.options["ELIST"]             

  end  
  
end