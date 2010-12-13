require "rubygems"
require "bundler"
Bundler.setup

require 'digest/sha1'
require 'digest/md5'
require "sinatra"
require "silo"

before do
  @silo = Silo.new settings.silo_root
end

get '/' do
  erb :index
end

post '/reserve' do
  url = File.dirname(request.url) + "/" + @params["ieid"]
  response = <<-RESPONSE
<?xml version="1.0" encoding="UTF-8"?>
<reserved location="#{url}" ieid="#{@params["ieid"]}"/>
RESPONSE
  halt 201, response
end

get '/:name' do |name|
  not_found unless @silo.has? name
  atom = @silo[name]
  response['Content-SHA1'] = atom.sha1
  response['Content-MD5'] = atom.md5
  send_file atom.data_path, :type => 'application/octet-stream'
end

put '/:name' do |name|
  halt 400, "#{name} already exists" if @silo.has? name
  @silo.write!(name) { |io| io.write request.body.read }

  ieid = File.basename request.url
  request.body.rewind
  md5 = Digest::MD5.hexdigest(request.body.read)
  request.body.rewind
  sha1 = Digest::SHA1.hexdigest(request.body.read)

  response = <<-RESPONSE
<?xml version="1.0" encoding="UTF-8"?>
<created location="#{request.url}" type="application/x-tar" md5="#{md5}" sha1="#{sha1}" size="#{request.body.size}" ieid="#{ieid}" name="#{ieid}"/>
  RESPONSE

  halt 201, response
end

delete '/' do
  @silo.nuke!
end

delete '/:name' do |name|
  not_found unless @silo.has? name
  @silo.delete! name
end
