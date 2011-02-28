class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.string :name
      t.string :sip
      t.string :phone
      t.boolean :browser
      t.string :pb_call_state
      t.datetime :pb_call_started
      t.datetime :pb_call_finished
      t.string :pb_output_recording
      t.string :pb_input_recording
      t.string :pb_input_output_flash
      t.references :room
      t.references :phonebrowser_service
      t.timestamps
    end
  end

  def self.down
    drop_table :participants
  end
end
