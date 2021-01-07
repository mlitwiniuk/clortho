class CreateSshKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :ssh_keys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :identifier
      t.text :key
      t.boolean :is_active

      t.timestamps
    end
  end
end
