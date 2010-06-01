require 'rubygems'
require 'bundler'
Bundler.setup

$LOAD_PATH.unshift File.join File.dirname(__FILE__), 'lib'
require 'app'

set :env, :production
disable :run, :reload

# set this to be where stuff is stored
set :silo_root, '/tmp'

run Sinatra::Application
