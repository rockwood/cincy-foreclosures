class PropertiesController < ApplicationController
  def index
    @properties = Property.geocoded
  end
end