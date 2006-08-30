ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
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

  def get_home_page
    get '/'
    assert_response :success
    assert_tag :tag => 'title', :content => 'Accademia dei Filodrammatici'
#    assert_template 'content/page'
  end

end
