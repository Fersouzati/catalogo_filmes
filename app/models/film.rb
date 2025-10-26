class Film < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
  validates :synopsis, presence: true, length: { minimum: 10 }
  validates :release_year, presence: true, numericality: { only_integer: true, greater_than: 1800, less_than_or_equal_to: Date.current.year }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :director, presence: true, length: { minimum: 2, maximum: 75 }

  has_many :film_categories, dependent: :destroy
  has_many :categories, through: :film_categories

  has_many :film_tags, dependent: :destroy
  has_many :tags, through: :film_tags

  has_one_attached :poster
  
  def tag_list
    tags.pluck(:name).join(', ')
  end
  
  def tag_list=(tags_string)
    
    tag_names = tags_string.split(',')
                           .collect{ |s| s.strip.downcase }
                           .uniq
    
    new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }

    self.tags = new_or_found_tags
  end
end