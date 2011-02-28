class CreatePhonebrowserServices < ActiveRecord::Migration
  def self.up
    create_table :phonebrowser_services do |t|
      t.string :phonebrowser_number
      t.string :listener_uri
      t.float :rate, :default => 0.025
      t.float :rate_mobile, :default => 0.129
      t.references :room
      t.references :service
      t.timestamps
    end
  end

  def self.down
    drop_table :phonebrowser_services
  end
end
