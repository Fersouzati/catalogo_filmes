require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "é válido com conteúdo e autor" do
    comment = build(:comment)
    expect(comment).to be_valid
  end

  it "é inválido sem conteúdo" do
    comment = build(:comment, content: nil)
    expect(comment).not_to be_valid
  end

  it "ordena do mais recente para o mais antigo" do
    old_comment = create(:comment, created_at: 1.day.ago)
    new_comment = create(:comment, created_at: Time.now)
    expect(Comment.order(created_at: :desc).first).to eq(new_comment)
  end
end