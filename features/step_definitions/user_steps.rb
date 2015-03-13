def add_doctor(first_name, last_name, email, phone_1, phone_2, phone_3)
  FactoryGirl.create(:doctor, :first_name => first_name, :last_name => last_name, :email => email, :phone_1 => phone_1, :phone_2 => phone_2, :phone_3 => phone_3)
end

Given /the following doctors exist/ do |doctors_table|
  doctors_table.hashes.each do |doctor|
    add_doctor(doctor['first_name'],doctor['last_name'],doctor['email'],doctor['phone_1'],doctor['phone_2'],doctor['phone_3'])
  end
end
