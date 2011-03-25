class CreateVideoServices < ActiveRecord::Migration
  def self.up
    create_table :video_services do |t|
      t.string :group_name
      t.references :service
      t.references :room
      t.timestamps
    end
    Service.create({:name => "video", :url => "http://arpameeting-video.arpamet.com", :port => 80, :status => "available"})
  end

  def self.down
    drop_table :video_services
  end
end
