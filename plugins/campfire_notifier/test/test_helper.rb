require 'rubygems'
require 'test/unit'
require 'mocha'

class BuilderPlugin; end
class Configuration; end
module CruiseControl; class Log; end; end
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'campfire_notifier'
