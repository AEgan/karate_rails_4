json.array!(@tournaments) do |tournament|
  json.extract! tournament, :id, :name, :date, :min_rank, :max_rank, :active
  json.url tournament_url(tournament, format: :json)
end
