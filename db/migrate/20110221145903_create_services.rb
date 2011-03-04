class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.string :name
      t.string :url
      t.integer :port
      t.string :status
      t.timestamps
    end
    Service.create({:name => "phonebrowser", :url => "http://coruscant.arpamet.com", :port => 5080, :status => "available"})
  end

  def self.down
    drop_table :services
  end
end
