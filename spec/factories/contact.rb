FactoryBot.define do
  factory :contact do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    phone { FFaker::PhoneNumberBR.mobile_phone_number }
    user  { build(:user) }
  end

  factory :contact_with_address, class: Contact do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    phone { FFaker::PhoneNumberBR.mobile_phone_number }
    user  { build(:user) }

    after(:create) {|contact| create(:address, contact: contact) }
  end

end
