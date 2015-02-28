json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :email_address, :is_admin
  json.url user_url(user, format: :json)
end
