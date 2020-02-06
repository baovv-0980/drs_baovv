Division.create!(name: "SUN")
1.times do |n|
  name  = Faker::Name.name
  email = "bao#{n}@gmail.com"
  password = "123456"
  User.create!(name:  name,
               email: email,
               password: password,
               password_confirmation: password,
               birthday: Time.zone.now,
               phone: "0388967331",
               skill: "Khong co ki nang chi",
               role: 2,
               division_id: 1)
end
