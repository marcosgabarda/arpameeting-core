class CreateFields < ActiveRecord::Migration
  def self.up
    create_table :fields do |t|
      t.string :key
      t.string :value
      t.references :service
      t.timestamps
    end
  end

  def self.down
    drop_table :fields
  end
end
