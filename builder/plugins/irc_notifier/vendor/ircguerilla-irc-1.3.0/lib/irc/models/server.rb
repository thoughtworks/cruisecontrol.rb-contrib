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
# $Id: server.rb 85 2006-08-13 11:42:07Z roman $
# 
require 'irc/models/network'

module IRC
  
  module Models
    
    class Server
      
      DEFAULT_PORT = 6667
      
      attr_reader :network
      attr_reader :hostname
      attr_reader :port
      
      attr_accessor :password
      attr_accessor :last_connect
      attr_accessor :last_disconnect
      
      # Creates a new server object with a hostname, an optional 
      # port and optinal password, that belongs to a network.  
      def initialize(attributes)
        
        raise ArgumentError.new("Can't create a new server object. The :network attribute is missing.") if attributes[:network] == nil
        @network = attributes[:network]
        
        raise ArgumentError.new("Can't create a new server object. The :hostname attribute is missing.") if attributes[:hostname] == nil
        @hostname = attributes[:hostname].strip
        
        @port = attributes[:port] || DEFAULT_PORT
        
        self.password = attributes[:password]
        self.last_connect = attributes[:last_connect]
        self.last_disconnect = attributes[:last_disconnect]
        
      end
      
      def ==(other)
        return eql?(other)
      end        
      
      # Returns true if the other Server object is equal to the
      # current.
      def eql?(other)
        return other.instance_of?(Server) && network == other.network && hostname == other.hostname && port == other.port    
      end
      
      def hash
        return key.hash
      end    
      
      def key
        return "#{network.name}|#{hostname}|#{port}".downcase
      end    
      
      def merge(other)
        
        #      @network = other.network
        @hostname = other.hostname
        @port = other.port
        
        self.password = other.password
        self.last_connect = other.last_connect
        self.last_disconnect = other.last_disconnect
        
      end
      
      # Returns the name of the server. If the port is different from the 
      # default IRC port the port number is also appended.
      def to_s
        return hostname
      end
      
      # Returns the name of the server. If the port is different from the 
      # default IRC port the port number is also appended.
      def to_str
        return to_s
      end
      
      def to_xml
        server = REXML::Element.new("Server")
        server.add_element("Hostname").add_text(REXML::CData.new(hostname))
        server.add_element("Port").add_text(port.to_s)
        server.add_element("Password").add_text(REXML::CData.new(password)) if password != nil      
        return server
      end    
      
    end
    
  end
  
end