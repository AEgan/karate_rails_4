json.array!(@dojos) do |dojo|
  json.extract! dojo, :id, :name, :city, :state, :street, :zip, :latitude, :longitude, :active
  json.url dojo_url(dojo, format: :json)
end
