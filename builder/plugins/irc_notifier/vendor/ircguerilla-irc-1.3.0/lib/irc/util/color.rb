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
module IRC
  
  module Util 
    
    class Color
      
      NORMAL = "\x0f"
      BOLD = "\x02"
      UNDERLINE = "\x1f"
      REVERSE = "\x16"
      
      WHITE = "\x030"
      BLACK = "\x031"
      DARK_BLUE = "\x032"
      DARK_GREEN = "\x033"
      RED = "\x034"
      BROWN = "\x035"
      PURPLE = "\x036"
      OLIVE = "\x037"
      YELLOW = "\x038"
      GREEN = "\x039"
      TEAL = "\x0310"
      CYAN = "\x0311"
      BLUE = "\x0312"
      MAGENTA = "\x0313"
      DARK_GRAY = "\x0314"
      LIGHT_GRAY = "\x0315"
      
      REGEXP_COLORS = Regexp.new("\x03(\\d\\d?(,\\d\\d?)?)?")
      
      REGEXP_FORMATTING = Regexp.new("#{NORMAL}|#{BOLD}|#{UNDERLINE}|#{REVERSE}")
      
      # Removes all IRC color characters from the given string.
      def self.remove_color(str)
        return str.gsub(REGEXP_COLORS, '')
      end
      
      # Removes all IRC color and formatting characters from the given string.
      def self.remove_color_and_formatting(str)
        return remove_color(remove_formatting(str))
      end
      
      # Removes all IRC formatting characters from the given string.    
      def self.remove_formatting(str)
        return str.gsub(REGEXP_FORMATTING, '')
      end
      
    end
    
  end
  
end