# == Schema Information
#
# Table name: addresses
#
#  id         :bigint           not null, primary key
#  city       :string
#  line1      :string
#  line2      :string
#  state      :string
#  zip        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  contact_id :bigint
#
# Indexes
#
#  index_addresses_on_contact_id  (contact_id)
#
# Foreign Keys
#
#  fk_rails_...  (contact_id => contacts.id)
#
FactoryBot.define do
  factory :address do
    line1 { FFaker::AddressBR.street_address }
    line2 { FFaker::AddressBR.neighborhood }
    city { FFaker::AddressBR.city }
    state { FFaker::AddressBR.state }
    zip { FFaker::AddressBR.zip_code }
    contact { build(:contact) }
  end
end
