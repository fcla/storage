app_file = File.join File.dirname(__FILE__), '..', 'app'
require app_file
require 'spec'
require 'rack/test'
require 'fileutils'

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
  SimpleStorage::App
end

app.set :environment, :test
