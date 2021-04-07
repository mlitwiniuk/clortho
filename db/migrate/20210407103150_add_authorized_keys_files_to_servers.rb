class AddAuthorizedKeysFilesToServers < ActiveRecord::Migration[6.1]
  def change
    add_column :servers, :authorized_keys_file, :string, default: 'authorized_keys'
  end
end
