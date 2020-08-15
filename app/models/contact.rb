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
class Contact < ApplicationRecord
  belongs_to :user

  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true
  
  validates :name, :user, presence: true

  paginates_per 10

end
