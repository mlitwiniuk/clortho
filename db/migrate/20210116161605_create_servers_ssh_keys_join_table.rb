class CreateServersSshKeysJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :servers, :ssh_keys
  end
end
