# == Schema Information
#
# Table name: contacts
#
#  id          :bigint           not null, primary key
#  description :text
#  email       :string
#  name        :string
#  phone       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_contacts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Contact, type: :model do
  it 'should not create contact without user' do
    contact = build(:contact, user: nil)
    expect(contact).to_not be_valid
  end

  it 'should not create contact without name' do
    contact = build(:contact, name: nil)
    expect(contact).to_not be_valid
  end

  it 'should create contact with name and user' do
    contact = build(:contact)
    expect(contact).to be_valid
  end
end
