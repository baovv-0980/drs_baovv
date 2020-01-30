User.create!(name: "ADMIN",
             email: "bao0@gmail.com",
             password: "123456",
             password_confirmation: "123456",
             birthday: Time.zone.now,
             phone: "0388967331",
             skill: "Khong co ki nang chi",
             role: 2,
             division_id: nil)
end
