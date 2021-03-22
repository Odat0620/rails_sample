FactoryBot.define do
  factory :relationship do
    follower_id   { FactoryBot.create(:user).id }
    followiing_id { FactoryBot.create(:user).id }
  end
end
