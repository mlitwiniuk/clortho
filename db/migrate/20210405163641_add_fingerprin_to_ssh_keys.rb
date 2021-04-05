class AddFingerprinToSshKeys < ActiveRecord::Migration[6.1]
  def change
    add_column :ssh_keys, :fingerprint, :string
    add_index :ssh_keys, :fingerprint, unique: true
  end
end
