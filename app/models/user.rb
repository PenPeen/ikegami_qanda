class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # :confirmable ← 公開用環境ではコメントアウト 
  
  # レコードの関連性
  has_many :questions ,dependent: :nullify #ユーザー削除時、questionsテーブルのuser_idはNULLとする
  
end
