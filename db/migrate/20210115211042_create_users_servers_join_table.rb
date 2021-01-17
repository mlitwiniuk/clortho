class CreateUsersServersJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :servers, :users
  end
end
