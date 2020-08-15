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
class Address < ApplicationRecord
  belongs_to :contact

  validates :line1, :line2, :city, :state, :zip, :contact, presence: true 
end
