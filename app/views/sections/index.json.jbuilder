json.array!(@sections) do |section|
  json.extract! section, :id, :active, :event_id, :max_age, :min_age, :max_rank, :min_rank
  json.url section_url(section, format: :json)
end
