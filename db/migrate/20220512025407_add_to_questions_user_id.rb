class AddToQuestionsUserId < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :user, foreign_key: true
    # t.references :question, null: false, foreign_key: true
  end
end
