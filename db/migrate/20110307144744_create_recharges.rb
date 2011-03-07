class CreateRecharges < ActiveRecord::Migration
  def self.up
    create_table :recharges do |t|
      t.references :user
      t.string :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :recharges
  end
end
