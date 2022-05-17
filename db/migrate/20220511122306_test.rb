class Test < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :boolean, default: false
  end
end
