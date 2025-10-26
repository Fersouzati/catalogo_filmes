class Comment < ApplicationRecord
  belongs_to :film
  belongs_to :user, optional: true

  validates :content, presence: true
end
