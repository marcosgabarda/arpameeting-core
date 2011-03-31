class AddVideoServiceToParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :video_service_id, :integer
  end

  def self.down
    remove_column :participants, :video_service_id
  end
end
