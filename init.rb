require 'sinatra'

require './app/helpers/application_helper.rb'
Dir.glob('./app/{models,helpers,controllers}/*.rb').sort.each { |file|
  puts file
  require file
}
