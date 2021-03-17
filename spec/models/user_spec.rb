require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    @user = build(:user)
  end

  it "ユーザー登録が可能である" do
    expect(@user).to be_valid
  end

  describe 'バリデーション' do
    context "ユーザーが保存できる場合" do
      it 'emailが255文字以下のユーザーを許可する' do
        @user.email = 'a' * 243 + '@example.com'
        expect(@user).to be_valid
      end
      it 'passwordが6文字以上で作成可能' do
        @user.password = @user.password_confirmation = 'a' * 6
        expect(@user).to be_valid
      end
      it 'emailが重複していなければ成功' do
        user = create(:user)
        user2 = build(:user)
        expect(user2).to be_valid
      end
      it 'emailは全て小文字で保存される' do
        @user.email = 'EXAMPLE@EXAMPLE.COM'
        @user.save!
        expect(@user.reload.email).to eq 'example@example.com'
      end
    end
    
    context "ユーザーが保存できない場合" do
      it 'nameが空の場合、無効である' do
        @user.name = " "
        @user.valid?
        expect(@user.errors).to be_added(:name, :blank)
      end
      it 'emailが空の場合、無効である' do
        @user.email = " "
        @user.valid?
        expect(@user.errors).to be_added(:email, :blank)
      end
      it 'passwordが空の場合、無効である' do
        @user.password = " "
        @user.valid?
        expect(@user.errors).to be_added(:password, :blank)
      end
      it 'emailが256文字以上のユーザーを許可しない' do
        @user.email = 'a' * 244 + '@example.com'
        @user.valid?
        expect(@user.errors).to be_added(:email, :too_long, count: 255)
      end
      it 'passwordが6文字未満はエラー' do
        @user.password = 'a' * 5
        @user.valid?
        expect(@user.errors).to be_added(:password, :too_short, count: 6)
      end
      it 'nameが21文字以上のユーザーはエラー' do
        @user.name = 'a' * 21
        @user.valid?
        expect(@user.errors).to be_added(:name, :too_long, count: 20)
      end
      it 'emailが重複しているとエラー' do
        user = create(:user, email: 'example@example.com')
        user2 = build(:user, email: 'example@example.com')
        user2.valid?
        expect(user2.errors).to be_added(:email, :taken, value: 'example@example.com')
      end
    end
  end
end