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
# $Id: user.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/models/network'

module IRC
  
  module Models
    
    class User
      
      attr_reader :network
      attr_reader :nick
      
      attr_accessor :login
      attr_accessor :hostname  
      attr_accessor :realname
      
      def initialize(attributes)
        
        raise ArgumentError.new("Can't create a new user object. The :network attribute is missing.") if attributes[:network] == nil
        @network = attributes[:network]
        
        raise ArgumentError.new("Can't create a new user object. The :nick attribute is missing.") if attributes[:nick] == nil
        @nick = attributes[:nick].strip
        
        @login = attributes[:login]
        @hostname = attributes[:hostname]
        
        @channels = Hash.new
        
      end
      
      def add_channel(channel)
        @channels[channel] = channel
      end
      
      def channels
        return @channels.values
      end
      
      def eql?(other)
        return (other.instance_of?(Bot) || other.instance_of?(User)) && network == other.network && nick == other.nick
      end   
      
      def hash
        return key.hash
      end         
      
      def key
        return "#{network.name.strip}|#{nick.strip}".downcase
      end
      
      def merge(other)
        
        @nick = other.nick
        
        self.login = other.login
        self.hostname = other.hostname
        
        other.channels.each do |other_channel|
          channel = network.lookup_or_create_channel(other_channel.name)
          add_channel(channel)
        end
        
      end
      
      def remove_channel(channel)
        return @channels.delete(channel)
      end
      
      # Returns the nick name of the user.
      def to_s
        return @nick
      end    
      
      # Returns the nick name of the user.
      def to_str
        return to_s
      end    
      
      def ==(other)
        return eql?(other)
      end        
      
    end
    
  end
  
end