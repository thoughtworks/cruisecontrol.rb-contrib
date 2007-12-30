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
# $Id: bot.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/models/user'
require 'irc/models/packet'

module IRC

  module Models
    
    class Bot < User
      
      attr_accessor :bot_type
      
      attr_accessor :bandwidth_capacity
      attr_accessor :bandwidth_current
      attr_accessor :bandwidth_record
      
      attr_accessor :command_details
      attr_accessor :command_list
      attr_accessor :command_request
      
      attr_accessor :queue_position        
      attr_accessor :queue_size    
      
      attr_accessor :slots_open
      attr_accessor :slots_total
      
      attr_accessor :transfer_max
      attr_accessor :transfer_min
      attr_accessor :transfer_record
      
      def initialize(attributes)
        
        super(attributes)
        
        self.bot_type = attributes[:bot_type]
        
        self.bandwidth_capacity = attributes[:bandwidth_capacity]
        self.bandwidth_current = attributes[:bandwidth_current]
        self.bandwidth_record = attributes[:bandwidth_record]
        
        self.command_details = attributes[:command_details]
        self.command_list = attributes[:command_list]
        self.command_request = attributes[:command_request]
        
        self.queue_position = attributes[:queue_position]        
        self.queue_size = attributes[:queue_size]    
        
        self.slots_open = attributes[:slots_open]
        self.slots_total = attributes[:slots_total]
        
        self.transfer_max = attributes[:transfer_max]
        self.transfer_min = attributes[:transfer_min]
        self.transfer_record = attributes[:transfer_record]
        
        @channels = Hash.new
        @packets = Array.new
        
      end
      
      def add_channel(channel)
        @channels[channel.hash] = channel
        return channel
      end
      
      def channels
        return @channels.values
      end
      
      def create_packet(number, description, size_in_bytes = nil, number_of_downloads = nil)
        raise Exception.new("Can't create packet. A packet with the same number does already exist.") if packet(number) != nil
        packet = Packet.new(:bot => self, :number => number, :description => description, :size_in_bytes => size_in_bytes, :number_of_downloads => number_of_downloads)
        @packets[number - 1] = packet
        return packet
      end
      
      def merge(other)
        
        super(other)
        
        return if !other.kind_of?(Bot) && !other.kind_of?(IRC::Bot)
        
        self.bot_type = other.bot_type
        
        self.bandwidth_capacity = other.bandwidth_capacity
        self.bandwidth_current = other.bandwidth_current
        self.bandwidth_record = other.bandwidth_record
        
        self.command_details = other.command_details
        self.command_list = other.command_list
        self.command_request = other.command_request
        
        self.queue_position = other.queue_position        
        self.queue_size = other.queue_size    
        
        self.slots_open = other.slots_open
        self.slots_total = other.slots_total
        
        self.transfer_max = other.transfer_max
        self.transfer_min = other.transfer_min
        self.transfer_record = other.transfer_record
        
        other.packets do |packet|
          @packets[packet.number - 1] = packet
        end
        
      end    
      
      def update_packet(number, description, size_in_bytes = nil, number_of_downloads = nil)
        
        # Find existing packet by number, or return with a new packet.
        packet = packet(number)
        return create_packet(number, description, size_in_bytes, number_of_downloads) if packet == nil
        
        # Update already existing packet.
        packet.description = description
        packet.size_in_bytes = size_in_bytes
        packet.number_of_downloads = number_of_downloads            
        
        return packet
        
      end  
      
      def packet(number)
        @packets[number - 1]   
      end
      
      def packets
        return @packets.compact
      end
      
    end
  
  end  
  
end
