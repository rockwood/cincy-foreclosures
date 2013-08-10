class PropertiesController < ApplicationController
  def index
    @properties = Property.current.geocoded
  end
end