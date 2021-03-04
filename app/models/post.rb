class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  #バリデーション
  validates :title, presence: true, length: { maximum: 20 }
end
