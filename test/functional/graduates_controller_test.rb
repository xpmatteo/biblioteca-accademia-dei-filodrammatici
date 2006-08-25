require File.dirname(__FILE__) + '/../test_helper'
require 'graduates_controller'

# Re-raise errors caught by the controller.
class GraduatesController; def rescue_action(e) raise e end; end

class GraduatesControllerTest < Test::Unit::TestCase
  fixtures :graduates

  def setup
    @controller = GraduatesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_index
    get :index
    assert_response :success
    assert_template 'index'
  end

  def test_list_by_year
    get :list, :year => 2003 
    assert_number_of_graduates_assigned_equals 2

    get :list, :year => 2004
    assert_number_of_graduates_assigned_equals 0
  end                   
  
  def test_list_by_initial
    get :list, :initial => 'Z' 
    assert_number_of_graduates_assigned_equals 0

    get :list, :initial => 'G' 
    assert_number_of_graduates_assigned_equals 1

    get :list, :initial => 'D' 
    assert_number_of_graduates_assigned_equals 2
    assert_equal ['De Geppis', 'De Pippis'], last_names_of_assigned_graduates
  end

  def test_list_view_contains_links_to_details
    get :list, :year => 2003 
    assert_tag :tag => 'a', :content => 'DE PIPPIS Pippo', 
      :attributes => { :href => '/diplomati/show/2'}
  end                                         
  
  def test_list_view_contains_list_of_years
    get :list
    assert_view_contains_list_of_years
  end

  def test_list_view_contains_list_of_initials
    get :list
    assert_equal [], assigns(:initials)
    assert_tag :attributes => { :id => 'initials' }
  end
  
  def test_form_contains_all_text_fields    
    get :edit, :id => 1

    fields = Graduate::ANAGRAPHIC_ATTRIBUTES.merge(Graduate::ADDRESS_ATTRIBUTES).merge(Graduate::OTHER_ATTRIBUTES)
    for name in fields.keys
      assert_tag :tag => 'input',
        :attributes => { :type => 'text', :name => "graduate[#{name.to_s}]" }
    end
  end

  def test_list_view_contains_list_of_initials
    get :list
    assert_equal ['D', 'G'], assigns(:initials)
    assert_tag :attributes => { :id => 'initials' }
    assert_view_contains_link_to_initial 'D'
    assert_view_contains_link_to_initial 'G'
  end

  def test_find_by_initial_orders_by_last_name
    insert_graduate_with_last_name 'Zzz'
    insert_graduate_with_last_name 'Zbb'
    insert_graduate_with_last_name 'Zaa'
    get :list, :initial => 'Z'
    assert_equal ['Zaa', 'Zbb', 'Zzz'], last_names_of_assigned_graduates
  end                                                        
  
  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_number_of_graduates_assigned_equals Graduate.count
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:graduate)
    assert assigns(:graduate).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:graduate)
  end

  def test_create
    num_graduates = Graduate.count

    post :create, :graduate => graduates(:gino).attributes

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_graduates + 1, Graduate.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:graduate)
    assert assigns(:graduate).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Graduate.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Graduate.find(1)
    }
  end
  
private
  def assert_number_of_graduates_assigned_equals(expected)
    assert_not_nil assigns(:graduates), "didn't assign to graduates"
    assert_equal expected, assigns(:graduates).size, "number of graduates different from expected"
  end
  
  def assert_view_contains_link_to_year(year)
    assert_tag :content => year.to_s, :tag => 'a',
      :attributes => { :href => "/diplomati/list?year=#{year}" }
  end

  def assert_view_contains_link_to_initial(initial)
    assert_tag :content => initial, :tag => 'a',
      :attributes => { :href => "/diplomati/list?initial=#{initial}" }
  end

  def insert_graduate_with_last_name(last)
    g = Graduate.new(graduates(:gino).attributes)
    g.last_name = last                   
    assert g.save
    g
  end
  
  def last_names_of_assigned_graduates
    assigns(:graduates).map { |g| g.last_name }
  end
  
  def assert_view_contains_list_of_years
    assert_equal [2003, 2005], assigns(:graduation_years)
    assert_tag :attributes => { :id => 'graduation-years' }
    assert_view_contains_link_to_year 2003
    assert_view_contains_link_to_year 2005
  end
end
