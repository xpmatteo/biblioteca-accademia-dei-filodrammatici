if RAILS_ENV == 'test'
  require "form_test_helper"

  dir = File.expand_path(File.dirname(__FILE__))
  Dir[dir + "/lib/*.rb"].each do |file|
    require file
  end

  Test::Unit::TestCase.class_eval do
    include FormTestHelper::LinkMethods
    include FormTestHelper::FormMethods
    include FormTestHelper::RequestMethods    
  end

  # I have to include FormTestHelper this way or it loads from gems and not vendor:
  module ActionController::Integration
    class Session
      include FormTestHelper::LinkMethods
      include FormTestHelper::FormMethods
      include FormTestHelper::RequestMethods
    end
  end

  require 'rails_1-1-6_hack' unless CGIMethods.const_defined? "FormEncodedPairParser"
end