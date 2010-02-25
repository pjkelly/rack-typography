require 'test_helper'

class RackTypographyTest < Test::Unit::TestCase

  def get_response(path, body, content_type = 'text/html', options = {})
    app = Rack::Builder.new do
      use Rack::Typography, options
      run lambda { |env| [200, {'Content-Type' => content_type}, [body] ] }
    end
    Rack::MockRequest.new(app).get(path)
  end
    
  context "Rack::Typography" do  
    context "with content type equal to 'text/html'" do
      should "clean response body" do
        response = get_response('/', '<p>Marley & Me.</p>')
        assert_equal response.body, '<p>Marley <span class="amp">&amp;</span>&nbsp;Me.</p>'
      end
    end
  end
end