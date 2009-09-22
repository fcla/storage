require "spec_helper"

describe SimpleStorage::App do

  before(:all) do
    @sandbox = new_sandbox
    FileUtils::mkdir @sandbox
    app.set :silo_root, @sandbox
  end

  after(:all) do
    FileUtils::rm_r @sandbox
  end

  before(:each) do
    FileUtils::rm_rf Dir[File.join(@sandbox, '*')]
  end

  it "should allow putting of stuff" do
    put "/foo", "FOO", 'Content-Type' => 'text/plain'
    last_response.status.should == 201
  end
  
  it "should not allow putting of stuff that exists" do
    put "/foo", "FOO", 'Content-Type' => 'text/plain'
    put "/foo", "BAR", 'Content-Type' => 'text/plain'
    last_response.should_not be_ok
  end
  
  it "should allow getting of stuff" do
    put "/foo", "FOO", 'Content-Type' => 'text/plain'
    get "/foo"
    last_response.should be_ok
    last_response.body.should == "FOO"
  end
  
  it "should not allow getting of stuff that does not exist" do
    get "/foo"
    last_response.should_not be_ok
  end
  
  it "should allow deleting of stuff" do
    put "/foo", "FOO", 'Content-Type' => 'text/plain'
    delete "/foo"
    last_response.should be_ok
    get "/foo"
    last_response.should_not be_ok    
  end
  
  it "should not allow deleting of stuff that does not exist" do
    delete "/foo"
    last_response.should_not be_ok
  end

  it "should all deletion of everything" do
    put "/foo", "FOO", 'Content-Type' => 'text/plain'
    put "/bar", "BAR", 'Content-Type' => 'text/plain'
    
    delete "/"
    last_response.should be_ok
    
    get "/foo"
    last_response.should_not be_ok
    get "/bar"
    last_response.should_not be_ok
  end
  
  it "should list all stuff in the silo" do
    put "/foo", "FOO", 'Content-Type' => 'text/plain'
    put "/bar", "BAR", 'Content-Type' => 'text/plain'
    put "/baz", "BAZ", 'Content-Type' => 'text/plain'
    get '/'
    last_response.should be_ok
    last_response.body.should =~ %r{foo}
    last_response.body.should =~ %r{bar}
    last_response.body.should =~ %r{baz}
  end
  
end