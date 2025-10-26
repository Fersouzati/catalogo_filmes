require 'rails_helper'

RSpec.describe Film, type: :model do
  it "é válido com atributos válidos" do
    film = build(:film) 
    expect(film).to be_valid
  end

  it "é inválido sem título" do
    film = build(:film, title: nil)
    expect(film).not_to be_valid
  end

  it "ordena por mais recente primeiro" do
    old_film = create(:film, release_year: 2020)
    new_film = create(:film, release_year: 2023)
    expect(Film.order(release_year: :desc).first).to eq(new_film)
  end
end