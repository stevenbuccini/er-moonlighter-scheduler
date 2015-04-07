Factory.define :doctor do |d|
  d.created_at '2015-03-13 04:08:15'
  d.updated_at '2015-03-13 04:08:15'
  d.reset_password_sent_at nil
  d.reset_password_token nil
  d.remember_created_at nil
  d.password 'password'
  d.email 'mnitche@example.com'
  d.current_sign_in_at nil
  d.last_sign_in_at nil
  d.current_sign_in_ip nil
  d.last_sign_in_ip nil
  d.first_name 'Doctor'
  d.last_name 'Factory'
  d.type 'Doctor'
  d.phone_1 '123-456-7890'
  d.phone_2 '760-805-9889'
  d.phone_3 '122-222-2345'
end

Factory.define :admin do |a|
  a.created_at '2015-03-13 04:08:15'
  a.updated_at '2015-03-13 04:08:15'
  a.reset_password_sent_at nil
  a.reset_password_token nil
  a.remember_created_at nil
  a.password 'dudududu'
  a.email 'admin@factory.com'
  a.current_sign_in_at nil
  a.last_sign_in_at nil
  a.current_sign_in_ip nil
  a.last_sign_in_ip nil
  a.first_name 'Factory'
  a.last_name 'Admin'
  a.type 'Admin'
  a.phone_1 '123-456-7890'
  a.phone_2 '760-805-9889'
  a.phone_3 '122-222-2345'
end

Factory.define :shift do |s|
  s.created_at '2015-03-13 04:08:15'
  s.updated_at '2015-03-13 04:08:15'
  s.start_datetime DateTime.new(2015, 2, 14, 8, 00)
  s.end_datetime DateTime.new(2015, 2, 14, 13, 00)
  s.confirmed false
  s.doctor_id nil
end


Factory.define :user do |a|
  a.created_at '2015-03-13 04:08:15'
  a.updated_at '2015-03-13 04:08:15'
  a.reset_password_sent_at nil
  a.reset_password_token nil
  a.remember_created_at nil
  a.password 11111111
  a.email 'newuser@example.com'
  a.current_sign_in_at nil
  a.last_sign_in_at nil
  a.current_sign_in_ip nil
  a.last_sign_in_ip nil
  a.first_name 'new'
  a.last_name 'user'
  a.phone_1 '123-456-7890'
  a.phone_2 '760-805-9889'
  a.phone_3 '122-222-2345'
end