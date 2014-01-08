json.array!(@registrations) do |registration|
  json.extract! registration, :id, :section_id, :student_id, :date
  json.url registration_url(registration, format: :json)
end
