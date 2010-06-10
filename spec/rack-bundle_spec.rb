require File.join(File.dirname(__FILE__), 'spec_helper')

describe Rack::Bundle do
  before do
    @bundle = Rack::Bundle.new(index_page, :js_path => FIXTURES_PATH, :css_path => FIXTURES_PATH, :public => FIXTURES_PATH)
    @env    = Rack::MockRequest.env_for('/')
    status, headers, @response = @bundle.call(@env)
  end
  
  it "needs to know where the application's public directory is" do
    lambda do Rack::Bundle.new(index_page) end.should raise_error(ArgumentError)
  end

  it 'defaults to FileSystemStore for storage' do
    Rack::Bundle.new(index_page, :public => '.').storage.is_a? Rack::Bundle::FileSystemStore
  end
  
  it "won't bundle Javascripts unless it knows the path to where they're stored"
  it "won't bundle stylesheets unless it knows the path to where they're stored"

  context 'parsing HTML' do
    it "doesn't happen unless the response is HTML" do
      bundle = Rack::Bundle.new plain_text, :public => FIXTURES_PATH
      bundle.should_not_receive :parse!
      bundle.call(@env)
    end

    it 'does so with Nokogiri' do
      @bundle.document.should be_a Nokogiri::HTML::Document
    end
        
    it "replaces all external links to Javascript for one single link to a bundle"
    it "replaces all external links to stylesheets for one single link to a bundle per media type"

    it "stores the bundle(s) using the currently available storage engine"
  end
  
  context 'modifying the DOM' do
    it "adds a <script> tag to the document's head linking the Javascript bundle, then removes all others" do
    end
  end
  
  context 'private methods' do
    it 'returns a URL to a bundle on #bundle_path' do
      @jsbundle = Rack::Bundle::JSBundle.new 'omg'
      @bundle.send(:bundle_path, @jsbundle).should == "/rack-bundle-#{@jsbundle.hash}.js"
    end
  end
end