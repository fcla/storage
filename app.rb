require 'digest/sha1'
require 'digest/md5'
require "sinatra/base"
require "silo"

module SimpleStorage

  class App < Sinatra::Base

    set :root, File.dirname(__FILE__)
    
    def initialize(silo_root=nil)
      root = silo_root || options.silo_root
      raise 'silo root not specified' unless root
      @silo = Silo.new root
      super
    end

    get '/' do
      erb :index
    end
    
    get '/:name' do |name|
      not_found unless @silo.has? name
      content_type 'application/octet-stream'
      atom = @silo[name]
      response['Content-SHA1'] = atom.sha1
      response['Content-MD5'] = atom.md5
      send_file atom.data_path
    end
    
    put '/:name' do |name|
      halt 400, "#{name} already exists" if @silo.has? name
      @silo.write!(name) { |io| io.write request.body.read }
      status 201
    end
    
    delete '/' do
      @silo.nuke!
    end
    
    delete '/:name' do |name|
      not_found unless @silo.has? name
      @silo.delete! name
    end
    
  end

end

if __FILE__ == $0
  raise 'a silo root must be specified' unless ARGV.first  
  SimpleStorage::App.run! :silo_root => ARGV.first
end
