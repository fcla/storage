require "rubygems"
require "bundler"
Bundler.setup

require 'spec'
require 'rack/test'
require 'fileutils'

app_file = File.join File.dirname(__FILE__), '..', 'app'
require app_file

def new_sandbox
  tf = Tempfile.new 'sandbox'
  path = tf.path
  tf.close!
  path
end

Spec::Runner.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  Sinatra::Application
end

app.set :environment, :test
