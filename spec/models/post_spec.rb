require 'rails_helper'

RSpec.describe Post, type: :model do

  describe "投稿作成時" do
    it "投稿可能である" do
      expect(build(:post)).to be_valid
    end

    context "投稿できない場合" do
      it "タイトルがnilの場合保存できない" do
        post = build(:post, title: nil)
        post.valid?
        expect(post.errors[:title]).to include("タイトルを入力してください")
      end
      it "タイトルが21文字以上の場合保存できない" do
        post = build(:post, title: Faker::Lorem.characters(number: 21))
        post.valid?
        expect(post.errors[:title]).to include("タイトルは20文字以内で入力してください")
      end
    end
  end
end
