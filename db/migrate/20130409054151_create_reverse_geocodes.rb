class CreateReverseGeocodes < ActiveRecord::Migration
  def change
    create_table :reverse_geocodes do |t|
      t.boolean :is_started, :default=>false
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.boolean :is_processed, :default=> false
      t.text :error_message

      t.timestamps
    end
  end
end
