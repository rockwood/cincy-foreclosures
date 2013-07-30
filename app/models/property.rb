class Property < ActiveRecord::Base
  validates :address, uniqueness: true

  geocoded_by :full_street_address

  def full_street_address
    "#{address}, #{city}, #{state} #{zip}"
  end

  def self.geocode_all
    Property.not_geocoded.each do |property|
      property.geocode
      property.save
    end
  end
end
