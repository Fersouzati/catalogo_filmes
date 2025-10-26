class Category < ApplicationRecord
    has_many :film_categories, dependent: :destroy
    has_many :films, through: :film_categories
end
