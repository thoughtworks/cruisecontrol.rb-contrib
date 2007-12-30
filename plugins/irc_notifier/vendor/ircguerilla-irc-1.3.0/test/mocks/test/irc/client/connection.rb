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

require File.dirname(__FILE__) + '/../../../../../lib/irc/client/connection'

module IRC
  
  module Client
    
    class Connection
      
      attr_reader :context
      
      def connect(server)
      
        if context.input_socket == nil

          context.server = server
          
          register_connection_messages
          register_registration_messages
          
        end
  
        context.connect(server)
        
      end
      
      def register_raw_message(raw_message)
      
        # Create an input socket if not done already.
        context.input_socket ||= StringIO.new     
        
        # Save the input socket position and seek to the end.
        position = context.input_socket.pos
        context.input_socket.seek(0, IO::SEEK_END)
        
        # Append the raw message to the end of the string io object.
        context.input_socket << "#{IRC::Messages::Message.new(raw_message).to_s}\r\n"

        # Seek back to the saved position.
        context.input_socket.seek(position, IO::SEEK_SET)
        
      end
      
      def register_raw_messages(raw_messages)
        
        raw_messages.each do |raw_message| 
          register_raw_message(raw_message)
        end
        
      end
      
      def register_connection_messages
        
        raw_messages = [
          "NOTICE AUTH :*** Looking up your hostname...",
          "NOTICE AUTH :*** Checking Ident",
          "NOTICE AUTH :*** Found your hostname",
          "NOTICE AUTH :*** Got Ident response"
        ]
        
        register_raw_messages(raw_messages)
        
      end
      
      def register_registration_messages
        
        raw_messages = [
          ":#{context.server.hostname} 001 #{context.nick} :Welcome to the EFNet Internet Relay Chat Network #{context.nick}",
          ":#{context.server.hostname} 002 #{context.nick} :Your host is #{context.server.hostname}[#{context.server.hostname}/6667], running version ircd-ratbox-1.5-3",
          ":#{context.server.hostname} 003 #{context.nick} :This server was created Wto 30 Lis CET at 18:36:52 2004",
          ":#{context.server.hostname} 004 #{context.nick} #{context.server.hostname} ircd-ratbox-1.5-3 oiwszcerkfydnxbauglZ biklmnopstveI bkloveI",
          ":#{context.server.hostname} 005 #{context.nick} STD=i-d STATUSMSG=@+ KNOCK EXCEPTS INVEX MODES=4 MAXCHANNELS=25 MAXBANS=100 MAXTARGETS=4 NICKLEN=9 TOPICLEN=120 KICKLEN=120 :are supported by this server",
          ":#{context.server.hostname} 005 #{context.nick} CHANTYPES=#& PREFIX=(ov)@+ CHANMODES=eIb,k,l,imnpst NETWORK=EFNet CASEMAPPING=rfc1459 CHARSET=ascii CALLERID ETRACE WALLCHOPS SAFELIST ELIST=U :are supported by this server",
          ":#{context.server.hostname} 251 #{context.nick} :There are 8205 users and 63039 invisible on 59 servers",
          ":#{context.server.hostname} 252 #{context.nick} 437 :IRC Operators online",
          ":#{context.server.hostname} 254 #{context.nick} 33951 :channels formed",
          ":#{context.server.hostname} 255 #{context.nick} :I have 5548 clients and 1 servers",
          ":#{context.server.hostname} 265 #{context.nick} :Current local  users: 5548  Max: 6470",
          ":#{context.server.hostname} 266 #{context.nick} :Current global users: 71244  Max: 80036",
          ":#{context.server.hostname} 250 #{context.nick} :Highest connection count: 6471 (6470 clients) (217198 connections received)",
          ":#{context.server.hostname} 375 #{context.nick} :- #{context.server.hostname} Message of the Day -",
          ":#{context.server.hostname} 372 #{context.nick} :-",
          ":#{context.server.hostname} 372 #{context.nick} :- w   w w   w w   w   a  ttt m   m  ccc ooo m   m ppp l",
          ":#{context.server.hostname} 372 #{context.nick} :- w   w w   w w   w  a a  t  mm mm c    o o mm mm p p l",
          ":#{context.server.hostname} 372 #{context.nick} :- w w w w w w w w w aaaaa t  m m m c    o o m m m ppp l",
          ":#{context.server.hostname} 372 #{context.nick} :-  w w   w w   w w .a   a t  m   m .ccc ooo m   m.p   llll",
          ":#{context.server.hostname} 372 #{context.nick} :-",
          ":#{context.server.hostname} 372 #{context.nick} :- WWW.ATM.COM.PL",
          ":#{context.server.hostname} 372 #{context.nick} :-",
          ":#{context.server.hostname} 376 #{context.nick} :End of /MOTD command.",
          ":#{context.nick} MODE #{context.nick} :+i"
        ]
        
        register_raw_messages(raw_messages)
        
      end
      
      
    end
    
  end
  
end