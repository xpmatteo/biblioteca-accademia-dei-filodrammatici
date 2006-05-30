class Admin::NewsController < ApplicationController
  layout "admin"
  scaffold :news
end
