class AddPaidedToRooms < ActiveRecord::Migration
  def self.up
    add_column :rooms, :paided, :boolean
  end

  def self.down
    remove_column :rooms, :paided
  end
end
