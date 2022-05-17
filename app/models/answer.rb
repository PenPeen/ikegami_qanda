class Answer < ApplicationRecord
  # レコードの関連性
  belongs_to :question
  
  # 検証
  validates :name, presence: true
  validates :content, presence: true
end
