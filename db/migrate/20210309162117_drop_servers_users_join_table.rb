class DropServersUsersJoinTable < ActiveRecord::Migration[6.1]
  def change
    drop_join_table :servers, :users
  end
end
