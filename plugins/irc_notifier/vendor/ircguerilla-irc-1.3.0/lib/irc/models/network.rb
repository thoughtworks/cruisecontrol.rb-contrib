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
# $Id: network.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/models/bot'
require 'irc/models/channel'
require 'irc/models/server'
require 'irc/models/user'
require 'rexml/document'

module IRC
  
  module Models
    
    class Network
      
      attr_reader :name
      
      attr_accessor :description
      attr_accessor :last_connect
      attr_accessor :last_disconnect
      attr_accessor :last_observation_start
      attr_accessor :last_observation_stop
      
      def initialize(attributes)
        
        raise ArgumentError.new("Can't create a new network object. The :name attribute is missing.") if attributes[:name] == nil
        @name = attributes[:name].strip
        
        self.description = attributes[:description]
        self.last_connect = attributes[:last_connect]
        self.last_disconnect = attributes[:last_disconnect]
        self.last_observation_start = attributes[:last_observation_start]
        self.last_observation_stop = attributes[:last_observation_stop]
        
        @bots = Hash.new
        @channels = Hash.new
        @servers = Hash.new
        @users = Hash.new      
        
      end
      
      # Adds a bot to the network and returns the bot.
      def add_bot(bot)
        add_user(bot)
        return @bots[bot.key] = bot
      end
      
      # Adds a channel to the network and returns the channel.
      def add_channel(channel)
        return @channels[channel.key] = channel
      end
      
      # Adds a server to the network and returns the server.    
      def add_server(server)
        return @servers[server.key] = server
      end
      
      # Adds an user to the network and returns the user.
      def add_user(user)
        return @users[user.key] = user
      end
      
      # Returns all bots that are associated with this network.
      def bots
        return @bots.values
      end
      
      # Returns all channels that are associated with this network.
      def channels
        return @channels.values
      end
      
      # Creates a bot, adds it to the network and returns the new bot.
      def create_bot(nick, login = nil, hostname = nil) 
        return add_bot(Bot.new(:network => self, :nick => nick, :login => login, :hostname => hostname))
      end
      
      # Creates a channel, adds it to the network and returns the new channel.
      def create_channel(name , password = nil) 
        return add_channel(Channel.new(:network => self, :name => name, :password => password))
      end
      
      # Creates a server, adds it to the network and returns the new server.
      def create_server(hostname, port = Server::DEFAULT_PORT) 
        return add_server(Server.new(:network => self, :hostname => hostname, :port => port))
      end
      
      # Creates a user, adds it to the network and returns the new user.
      def create_user(nick, login = nil, hostname = nil) 
        return add_user(User.new(:network => self, :nick => nick, :login => login, :hostname => hostname))
      end
      
      # Returns true if the other Network object is equal to the current.
      def eql?(other)
        return other.instance_of?(Network) && name == other.name    
      end    
      
      # Looks up or creates a new bot object and adds that bot to the
      # internal hash table of bots. 
      def lookup_or_create_bot(nick, login = nil, hostname = nil) 
        return lookup_bot(nick) || create_bot(nick, login, hostname)
      end
      
      def hash
        return key.hash
      end
      
      def key
        return name.downcase
      end
      
      # Looks up or creates a new channel. The method returns the channel
      # that was found or created.
      def lookup_or_create_channel(name, password = nil) 
        return lookup_channel(name) || create_channel(name, password)
      end
      
      # Looks up or creates a new server. The method returns the server
      def lookup_or_create_server(hostname, port = Server::DEFAULT_PORT) 
        return lookup_server(hostname, port) || create_server(hostname, port)
      end
      
      # Looks up or creates a new user object and adds that user to the
      # internal hash table of users. 
      def lookup_or_create_user(nick, login = nil, hostname = nil) 
        return lookup_user(nick) || create_user(nick, login, hostname)
      end
      
      # Returns a bot object by its nick name or nil if there is no 
      # such bot associated with the network.
      def lookup_bot(nick) 
        return @bots[Bot.new(:network => self, :nick => nick).key]
      end
      
      # Returns a channel object by its name or nil if there is no 
      # such channel associated with the network.
      def lookup_channel(name) 
        return @channels[Channel.new(:network => self, :name => name).key]
      end
      
      # Returns a server object by its name and port number or nil
      # if there is no such server associated with the network.
      def lookup_server(hostname, port = Server::DEFAULT_PORT) 
        return @servers[Server.new(:network => self, :hostname => hostname, :port => port).key]
      end
      
      # Returns a user object by its nick name or nil if there is no 
      # such user associated with the network.
      def lookup_user(nick) 
        return @users[User.new(:network => self, :nick => nick).key] || lookup_bot(nick)
      end
      
      def merge(other)
        
        @name = other.name
        self.description = other.description
        
        self.last_connect = other.last_connect
        self.last_disconnect = other.last_disconnect
        
        self.last_observation_start = other.last_observation_start
        self.last_observation_stop = other.last_observation_stop
        
        #      other.bots.each do |bot|
        #        add_bot(bot)
        #        add_user(bot)        
        #      end
        
        other.channels.each do |other_channel|
          channel = lookup_or_create_channel(other_channel.name)
          channel.merge(other_channel)
        end
        
        other.servers.each do |other_server|
          server = lookup_or_create_server(other_server.hostname, other_server.port)
          server.merge(other_server)
        end
        #      
        #      other.users do.each |user|
        #        add_user(user)
        #      end
        
      end
      
      # Returns all servers that are associated with this network.
      def servers
        return @servers.values
      end
      
      # Returns all users that are associated with this network.
      def users
        return (@users.values + bots).uniq
      end
      
      # Returns the name of the network converted to upper case.
      def to_s
        return name.upcase
      end
      
      # Returns the name of the network converted to upper case.
      def to_str
        return to_s
      end
      
      # Returns a XML representation of the network. 
      def to_xml
        
        network = REXML::Element.new("Network")
        network.add_element("Name").add_text(REXML::CData.new(name))
        network.add_element("Description").add_text(REXML::CData.new(description)) if description != nil
        
        channels_element = network.add_element("Channels")
        channels.each { |channel| channels_element.add_element(channel.to_xml) }
        
        servers_element = network.add_element("Servers")
        servers.each { |server| servers_element.add_element(server.to_xml) }
        
        return network
        
      end
      
      def ==(other)
        return eql?(other)
      end    
      
    end
    
  end
  
end