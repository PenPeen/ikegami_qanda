class AddColumnQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :progress, :string
  end
end
