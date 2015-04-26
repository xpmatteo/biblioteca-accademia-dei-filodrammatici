require File.dirname(__FILE__) + '/../test_helper'

# see http://broadcast.oreilly.com/2008/10/testing-rails-partials.html

class DocumentsController < ApplicationController
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
    @controller = DocumentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_foo

    render :partial => 'documents/form'
    assert_false @response.body.include?("raised"), "errore: #{@response.body}"
    assert_xml "<div>" + @response.body + "</div>"

    assert_text_area "Titolo", "title"
    assert_text_field "Id sbn", "id_sbn"    
    assert_text_field "Pubblicazione", "publication"
    assert_text_field "Editore (usato solo per le ricerche)", "publisher"
    assert_text_field "Luogo (usato solo per le ricerche)", "place"
    assert_text_field "Anno (usato solo per le ricerche)", "year"
    assert_text_area "Note", "notes"
    assert_text_field "Segnatura", "collocation"
    
    assert_text_field "Impronta", "footprint"
    assert_text_field "Descrizione fisica", "physical_description"
    assert_text_field "Numero bibliografia nazionale", "national_bibliography_number"
    assert_text_field "Collezione", "collection_name"
    assert_text_field "Volume o tomo (relativo alla collezione)", "collection_volume"
    assert_text_field "Numero della rivista in cui compare (se è uno spoglio)", "month_of_serial"
    assert_text_field "Valore", "value"
    assert_text_area "Note private dell'amministratore", "admin_notes"
    # puts "---"
    # puts @response.body
    # puts "---"
    
  end

  private
  
  def assert_text_field text_label, field_name
    the_id = "document_#{field_name}"
    the_name = "document[#{field_name}]"
    assert_xpath "//label[@for='#{the_id}'][text()=\"#{text_label}\"]"
    assert_xpath "//input[@type='text'][@id='#{the_id}'][@name='#{the_name}']"    
  end
  
  def assert_text_area text_label, field_name
    the_id = "document_#{field_name}"
    the_name = "document[#{field_name}]"
    assert_xpath "//label[@for='#{the_id}'][text()=\"#{text_label}\"]"
    assert_xpath "//textarea[@id='#{the_id}'][@name='#{the_name}']"    
  end
  
end
