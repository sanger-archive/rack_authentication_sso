require 'rubygems'
require 'test/unit'
require 'shoulda'
require "rack/test"
require "mocha"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rack_authentication_sso'

class Test::Unit::TestCase
end
