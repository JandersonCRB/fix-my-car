class CreateFixes < ActiveRecord::Migration[5.1]
  def change
    create_table :fixes do |t|
      t.references :requester
      t.references :mechanical
      t.decimal :latitude
      t.decimal :longitude
      t.integer :status
      t.timestamp :time

      t.timestamps
    end
  end
end
