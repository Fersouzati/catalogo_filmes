require 'rails_helper'

RSpec.describe "Usuário cria filme e comenta", type: :system do
  let(:user) { create(:user) }

  it "permite criar um filme e adicionar comentário" do
    driven_by(:rack_test)

    
    login_as(user, scope: :user)

    
    visit new_film_path
    fill_in "film_title", with: "Filme Teste Sistema"
    fill_in "film_synopsis", with: "Uma sinopse qualquer"
    fill_in "film_release_year", with: "2024"
    fill_in "film_duration", with: "120"
    fill_in "film_director", with: "Diretor Teste"
    click_button "Criar Filme"

    
    expect(page).to have_content("Film was successfully created.")
    expect(page).to have_content("Filme Teste Sistema")

    
    fill_in "comment_content", with: "Comentário de teste"
    click_button I18n.t('films.show.submit_comment')


    expect(page).to have_content("Comentário de teste")
  end
end