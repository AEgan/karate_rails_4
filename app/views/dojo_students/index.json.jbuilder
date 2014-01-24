json.array!(@dojo_students) do |dojo_student|
  json.extract! dojo_student, :id, :student_id, :dojo_id, :start_date, :end_date
  json.url dojo_student_url(dojo_student, format: :json)
end
