class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :zipcode
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.float :temp
      t.float :feelslike
      t.float :tempmin
      t.float :tempmax
      t.float :humidity

      t.timestamps
    end
    add_index :locations, :zipcode
  end
end
