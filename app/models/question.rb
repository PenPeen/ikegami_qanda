class Question < ApplicationRecord
  # モデルの関連付け
  belongs_to :user
  has_many :answers, dependent: :destroy
  
  # バリデーション
  validates :title, presence: true
  validates :name, presence: true
  validates :content, presence: true
  
end
