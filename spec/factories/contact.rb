FactoryBot.define do
  factory :contact do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    phone { FFaker::PhoneNumberBR.mobile_phone_number }
    user  { build(:user) }
  end
end
