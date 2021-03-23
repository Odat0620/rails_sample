require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:relationship) { create(:relationship) }
  describe "フォロー時" do
    context "フォローできる場合" do
      it "全てのパラメーターが揃っていれば保存できる" do
        expect(relationship).to be_valid
      end
    end

    context "フォローできない場合" do
      it "follower_idがnilの場合は保存できない" do
        relationship.follower_id = nil
        relationship.valid?
        expect(relationship.errors[:follower]).to include("を入力してください")
      end
      it "following_idがnilの場合は保存できない" do
        relationship.following_id = nil
        relationship.valid?
        expect(relationship.errors[:following]).to include("を入力してください")
      end
    end

    context "一位性の検証" do
      before do
        @relationship = create(:relationship)
        @user1 = build(:relationship)
      end
      it "follower_idとfollowing_idの組み合わせは一意でないと保存できない" do
        relationship2 = build(:relationship, follower_id: @relationship.follower_id, following_id: @relationship.following_id)
        relationship2.valid?
        expect(relationship2.errors[:follower]).to include("はすでに存在します")
      end
      it "follower_idが同じでもfollowing_idが違えば保存できる" do
        relationship2 = build(:relationship, follower_id: @relationship.follower_id, following_id: @user1.following_id)
        expect(relationship2).to be_valid
      end
      it "following_idが同じでもfollower_idが違えば保存できる" do
        relationship2 = build(:relationship, follower_id: @user1.follower_id, following_id: @relationship.following_id)
        expect(relationship2).to be_valid
      end
    end
  end

  describe "アソシエーション" do
    let(:association) do
      described_class.reflect_on_association(target)
    end
    context "User(follower)モデルとの関係" do
      let(:target) { :follower }
      it "1つのfollowerに対して、followingは多" do
        expect(association.macro).to eq :belongs_to
      end
    end

    context "User(following)モデルとの関係" do
      let(:target) { :following }
      it "1つのfollowingに対して、followerは多" do
        expect(association.macro).to eq :belongs_to
      end
    end
  end
end
