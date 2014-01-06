json.array!(@events) do |event|
  json.extract! event, :id, :name, :active
  json.url event_url(event, format: :json)
end
