class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  #バリデーション
  validates :content, presence: true, length: { maximum: 150 }
end
