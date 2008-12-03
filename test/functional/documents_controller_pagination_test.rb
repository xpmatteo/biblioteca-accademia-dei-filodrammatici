require File.dirname(__FILE__) + '/../test_helper'
require 'documents_controller'
require 'flexmock/test_unit'

# Re-raise errors caught by the controller.
class DocumentsController; def rescue_action(e) raise e end; end

class DocumentsControllerPaginationTest < Test::Unit::TestCase
  fixtures :authors, :publishers_emblems

  self.use_transactional_fixtures = true

  def setup
    @controller = DocumentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @collection = WillPaginate::Collection.create(1, 10) { |pager| pager.replace [Document.new(:title => "foo")] }    
  end

  def test_by_collection_should_pass_page_parameter
    expect_document_paginate_with(:collection_name => "foo bar", :page => "1")      
    get :collection, :name => "foo bar"
    
    expect_document_paginate_with :collection_name => "foo bar", :page => "3"
    get :collection, :name => "foo bar", :page => "3"
  end
  
  def test_by_author_should_pass_page_parameter
    author = authors(:mor_carlo)
    
    expect_document_paginate_with :author_id => author.id, :page => "1"   
    get :author, :id => author.id

    expect_document_paginate_with :author_id => author.id, :page => "45"
    get :author, :id => author.id, :page => 45
  end
  
  def test_by_year
    expect_document_paginate_with(:year => "1999", :page => "1")    
    get :year, :year => 1999
    
    expect_document_paginate_with(:year => "1999", :page => "44")    
    get :year, :year => 1999, :page => 44    
  end

  def test_by_publisher_emblem
    emblem = publishers_emblems(:leone_rampante)
    expect_document_paginate_with :publishers_emblem_id => emblem.id.to_s, :page => "1"
    get :publishers_emblem, :id => emblem.id
    
    expect_document_paginate_with :publishers_emblem_id => emblem.id.to_s, :page => "101"
    get :publishers_emblem, :id => emblem.id, :page => "101"    
  end
  
  def test_by_search_no_params
    expect_document_paginate_with({"page" => "1", "action" => "search", "controller" => "documents", })
    get :search
  end
  
  def test_by_search_with_some_params
    expect_document_paginate_with({"foo" => "bar", "page" => "1", "action" => "search", "controller" => "documents"})
    get :search, :foo => "bar"
  end

  def test_by_search_with_some_params_and_page
    expect_document_paginate_with({"page" => "234", "foo" => "bar", "action" => "search", "controller" => "documents"})
    get :search, :foo => "bar", :page => "234"
  end
  
  def test_find
    expect_document_paginate_with :keywords => "foo", :page => "1"
    get :find, :q => "foo"

    expect_document_paginate_with :keywords => "bar", :page => "23"
    get :find, :q => "bar", :page => "23"
  end
  
  private
  
  def expect_document_paginate_with options
    flexmock(Document).
      should_receive(:paginate).
      with(options).
      and_return(@collection)    
  end
end
