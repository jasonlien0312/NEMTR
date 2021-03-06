class Location
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  field :name, type: String
  field :addr1, type: String
  field :addr2, type: String
  field :city, type: String
  field :state, type: String
  field :zip, type: Integer

  field :address, type: String
  # field :latitude, type: Float
  # field :longitude, type: Float
  field :coordinates, type: Array

  embedded_in :Appointment
  # not working for me for some reason, made a hack solution 
  # geocoded_by :address, coordinates: :coords 
  # after_validation :geocode
  before_save :generate_full_address

  protected
  def generate_full_address
    temp_address = "#{addr1} #{addr2}, #{city}, #{state} #{zip}"
    # very hacky solution but after 3 hrs this auto geocode is still not working...
    result = Geocoder.search(temp_address)
    self.coordinates = result.first.coordinates
    self.address = result.first.address
  end

end
