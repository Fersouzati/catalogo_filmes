FactoryBot.define do
  factory :comment do
    content { "Comentário de teste" }
    author_name { "Anônimo" }
    association :film  
  end
end