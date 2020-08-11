class Contact < ApplicationRecord
  belongs_to :user

  validates :name, :user, presence: true

  paginates_per 10
end
