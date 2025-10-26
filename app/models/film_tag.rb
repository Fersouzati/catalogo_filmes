class FilmTag < ApplicationRecord
  belongs_to :film
  belongs_to :tag
end
