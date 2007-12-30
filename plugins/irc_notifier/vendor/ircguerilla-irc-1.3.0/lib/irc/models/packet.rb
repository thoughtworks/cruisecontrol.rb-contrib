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
# $Id: packet.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/models/user'

module IRC
  
  module Models
    
    class Packet 
      
      attr_reader :bot
      attr_reader :number
      
      attr_accessor :description
      attr_accessor :size_in_bytes
      attr_accessor :number_of_downloads   
      
      def initialize(attributes)
        
        raise ArgumentError.new("Can't create a new packet. The :bot attribute is missing.") if attributes[:bot] == nil
        @bot = attributes[:bot]
        
        raise ArgumentError.new("Can't create a new packet. The :number attribute is missing.") if attributes[:number] == nil
        @number = attributes[:number]
        
        self.description = attributes[:description]
        self.size_in_bytes = attributes[:size_in_bytes]
        self.number_of_downloads = attributes[:number_of_downloads]   
        
      end
      
      def merge(other)
        #      @bot = other.bot
        @number = other.number
        self.description = other.description
        self.size_in_bytes = other.size_in_bytes
        self.number_of_downloads = other.number_of_downloads
      end    
      
      def ==(other)
        return eql?(other)
      end        
      
      # Returns true if the other Packet object is equal to the current.
      def eql?(other)
        return other.instance_of?(Packet) && bot == other.bot && number == other.number && description == other.description
      end    
      
      def hash
        return key.hash
      end
      
      def key
        return "#{bot.network.name.strip}|#{bot.nick.strip}|#{number.to_s}".downcase
      end   
      
    end
    
  end
  
end
