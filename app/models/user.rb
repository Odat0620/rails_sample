class User < ApplicationRecord
  # 投稿#
  has_many :posts, dependent: :destroy
  #コメント#
  has_many :comments, dependent: :destroy
  #いいね#
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  #フォロー#
  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship",  dependent: :destroy
  has_many :followings, through: :following_relationships
  has_many :follower_relationships, foreign_key: "following_id",class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships

  #バリデーション#
  validates :name,  presence: true, length: { maximum: 20 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  
  mount_uploader :image, ImageUploader
  
  #すでにいいねしているか？
  def already_liked?(post)
    self.likes.exists?(post_id: post.id)
  end

  #すでにフォロー済みであればtrueを返す
  def following?(other_user)
    followings.include?(other_user)
  end
  
  #フォローするメソッド
  def follow(other_user)
    following_relationships.create(following_id: other_user.id)
  end

  #フォローを解除するメソッド
  def unfollow(other_user)
    following_relationships.find_by(following_id: other_user.id).destroy
  end
end
