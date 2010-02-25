require File.dirname(__FILE__) + '/spec_helper.rb'
require 'rack_typography_sample_data'

describe Rack::Typography do
  include RackTypographySampleData

  it "should specify version as a constant" do
    Rack::Typography::VERSION.should_not be_nil
  end

  def get_response(path, body, content_type = 'text/html', options = {})
    app = Rack::Builder.new do
      use Rack::Typography, options
      run lambda { |env| [200, {'Content-Type' => content_type}, [body] ] }
    end
    Rack::MockRequest.new(app).get(path)
  end

  describe 'with content equal to text/html' do

    describe 'with a valid path' do

      it "should convert & to &amp;" do
        response = get_response('/', '<p>Marley & Me.</p>')
        response.body.should == '<p>Marley &amp; Me.</p>'
      end

    end

  end
end
