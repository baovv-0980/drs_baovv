2.times do
  Division.create!(name: Faker::Name.name)
end

9.times do |n|
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
               role: 0,
               division_id: 1)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.reports.create!(title: content,
               plan: "khong co ke hoach gi",
               actual: "khong co ke hoach gi",
               next_plan: "khong co ke hoach gi",
               issue: "khong co ke hoach gi" )}
end
