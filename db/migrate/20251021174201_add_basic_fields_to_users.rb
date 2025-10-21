class AddBasicFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :address, :string
    add_column :users, :role, :integer, default: 0

    add_index :users, :email, unique: true unless index_exists?(:users, :email)
  end
end
