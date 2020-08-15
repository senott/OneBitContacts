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
require 'rails_helper'

RSpec.describe Address, type: :model do
  it 'should not create address without contact' do
    address = build(:address, contact: nil)
    expect(address).to_not be_valid
  end

  it 'should not create address without line1' do
    address = build(:address, line1: nil)
    expect(address).to_not be_valid
  end

  it 'should create address' do
    address = build(:address)
    expect(address).to be_valid
  end

end
