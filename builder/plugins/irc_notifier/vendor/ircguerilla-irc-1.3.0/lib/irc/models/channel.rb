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
# $Id: channel.rb 85 2006-08-13 11:42:07Z roman $
# 
module IRC
  
  module Models
    
    class Channel
      
      attr_reader :network
      attr_reader :name
      
      attr_accessor :last_ban
      attr_accessor :last_join    
      attr_accessor :last_join_failure
      attr_accessor :last_join_failure_reason
      attr_accessor :last_kick
      attr_accessor :last_kick_reason    
      attr_accessor :last_part    
      attr_accessor :password
      attr_accessor :topic
      attr_accessor :topic_author
      attr_accessor :last_topic_change
      
      # Creates a new channel object with a name and an optional 
      # topic, that belongs to a network.  
      def initialize(attributes)
        
        raise ArgumentError.new("Can't create a new channel object. The :network attribute is missing.") if attributes[:network] == nil
        @network = attributes[:network]
        
        raise ArgumentError.new("Can't create a new user object. The :name attribute is missing.") if attributes[:name] == nil
        @name = attributes[:name].strip
        
        self.last_ban = attributes[:last_ban]
        self.last_join = attributes[:last_join]
        self.last_join_failure = attributes[:last_join_failure]
        self.last_join_failure_reason = attributes[:last_join_failure_reason]
        self.last_kick = attributes[:last_kick]
        self.last_kick_reason = attributes[:last_kick_reason]
        self.last_part = attributes[:last_part]
        self.password = attributes[:password]
        self.topic = attributes[:topic]
        self.topic_author = attributes[:topic_author]
        self.last_topic_change = attributes[:last_topic_change]
        
        @users = Hash.new
        
      end
      
      def add_user(user)
        @users[user] = user
      end
      
      def ==(other)
        return eql?(other)
      end        
      
      # Returns true if the other Channel object is equal to the
      # current.
      def eql?(other)
        return other.instance_of?(Channel) && @network == other.network && @name == other.name    
      end    
      
      def hash
        return key.hash
      end    
      
      def key
        return "#{network.name}|#{name}".downcase
      end    
      
      def merge(other)
        
        #      @network = other.network
        @name = other.name
        
        self.last_ban = other.last_ban
        
        self.last_join = other.last_join    
        self.last_join_failure = other.last_join_failure
        self.last_join_failure_reason = other.last_join_failure_reason
        
        self.last_kick = other.last_kick
        self.last_kick_reason = other.last_kick_reason    
        
        self.last_part = other.last_part    
        
        self.password = other.password
        
        self.topic = other.topic
        self.topic_author = other.topic_author
        self.last_topic_change = other.last_topic_change
        
        other.users.each do |other_user|
          user = network.lookup_or_create_user(other_user.nick, other_user.login, other_user.hostname)
          add_user(other_user)
        end
        
      end
      
      def remove_user(user)
        return @users.delete(user)
      end
      
      def users
        return @users.values
      end
      
      # Returns true
      def self.is_valid?(channel_name)
        return Regexp.new('\s*#|&.*').match(channel_name) != nil
      end
      
      # Returns the name of the channel.
      def to_s
        return @name
      end
      
      # Returns the name of the channel.
      def to_str
        return to_s
      end
      
      def to_xml
        channel = REXML::Element.new("Channel")
        channel.add_element("Name").add_text(REXML::CData.new(name))
        channel.add_element("Password").add_text(REXML::CData.new(password)) if password != nil
        return channel
      end    
      
    end
    
  end
  
end