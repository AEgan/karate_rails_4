json.array!(@students) do |student|
  json.extract! student, :id, :first_name, :last_name, :phone, :rank, :waiver_signed, :active, :date_of_birth
  json.url student_url(student, format: :json)
end
