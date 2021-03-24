class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  #バリデーション
  validates :title, presence: true, length: { maximum: 20 }

  mount_uploader :image, ImageUploader
end
