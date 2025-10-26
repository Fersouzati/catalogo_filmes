class Tag < ApplicationRecord
    has_many :film_tags, dependent: :destroy
    has_many :films, through: :film_tags
end
