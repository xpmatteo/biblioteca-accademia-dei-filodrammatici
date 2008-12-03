ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  
  # la tabella documents deve usare MyIsam per la ricerca libera
  self.use_transactional_fixtures = false

  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...
  
  def assert_false(cond, msg=nil)
    assert !cond, msg
  end
  
  def assert_contains(needle, haystack)
    message = "looking for '#{needle}', not found in ''#{haystack}'"
    fail(message) unless Regexp.new(Regexp.escape(needle)) =~ haystack
  end
  
  def get_content_page(sym)
    content = contents(sym)
    get '/pagina/' + content.name
    assert_response :success
    assert_template 'content/page'
    assert_tag :tag => 'title', :content => 'Accademia dei Filodrammatici &mdash; ' + content.title
  end

  def fake_upload
    upload(Test::Unit::TestCase.fixture_path + '/files/animal.jpg', 'image/jpg')
  end

  def get_authenticated(action, params=nil)
    get action, params, { :authenticated => true }
  end

  def post_authenticated(action, params=nil)
    post action, params, { :authenticated => true }
  end
  
  def assert_protected(action)
    get action
    assert_redirected_to :controller => "login"
    assert_protected_post action
  end
  
  def assert_protected_post(action)
    post action
    assert_redirected_to :controller => "login"
  end
  
  def assert_modifications_are_protected
    assert_protected :edit
    assert_protected_post :update
    assert_protected :new
    assert_protected_post :create
    assert_protected_post :destroy
  end
  
  def save(record)
    assert record.save, record.errors.full_messages.join("; ")
  end
  
  def assert_invalid(record, message=nil)
    assert_false record.valid?, message
  end
  
  def create_100_documents_with(options)    
    100.times do |n| 
      Document.create options.merge(:title => sprintf("foo-%02d", n))
    end
  end
end
