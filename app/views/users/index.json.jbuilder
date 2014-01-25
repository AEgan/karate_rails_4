json.array!(@users) do |user|
  json.extract! user, :id, :email, :password_digest, :role, :student_id, :active
  json.url user_url(user, format: :json)
end
