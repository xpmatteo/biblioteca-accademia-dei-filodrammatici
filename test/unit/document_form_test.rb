require File.dirname(__FILE__) + '/../test_helper'

# see http://broadcast.oreilly.com/2008/10/testing-rails-partials.html

class ApplicationController
  def _renderizer
    @document = Document.new
    render params[:args]
  end
end

class Test::Unit::TestCase
  def render(args);  get :_renderizer, :args => args;  end
end

class DocumentFormTest < Test::Unit::TestCase
  self.use_transactional_fixtures = false  

  def setup
    @controller = ApplicationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_foo

    render :partial => 'documents/form'
    assert_false @response.body.include?("raised"), "errore: #{@response.body}"
    assert_xml "<div>" + @response.body + "</div>"
    # puts "---"
    # puts @response.body
    # puts "---"
    
  end

end
