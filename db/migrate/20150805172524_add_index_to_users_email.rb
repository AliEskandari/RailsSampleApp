class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	# uses a Rails method to add an index on the email col of the users table
  	# the option sets the index to enforce uniqueness
  	add_index :users, :email, unique: true
  end
end
