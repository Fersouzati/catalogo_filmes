FactoryBot.define do
  factory :film do
    title { "Filme Teste" }
    synopsis { "Uma sinopse qualquer" }
    release_year { 2024 }
    duration { 120 }
    director { "Diretor Teste" }
    association :user
  end
end
