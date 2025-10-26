json.extract! film, :id, :title, :synopsis, :release_year, :duration, :director, :user_id, :created_at, :updated_at
json.url film_url(film, format: :json)
