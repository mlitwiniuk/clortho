class AddLastSynchronizedAtToServers < ActiveRecord::Migration[6.1]
  def change
    add_column :servers, :last_synchronized_at, :datetime
  end
end
