class CreateServers < ActiveRecord::Migration[6.1]
  def change
    create_table :servers do |t|
      t.string :identifier
      t.string :host
      t.integer :port, default: 22
      t.string :user, default: 'deploy'

      t.timestamps
    end
  end
end
