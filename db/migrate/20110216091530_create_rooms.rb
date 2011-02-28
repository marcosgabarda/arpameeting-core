class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.references :user
      t.references :phonebrowser_service
      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
