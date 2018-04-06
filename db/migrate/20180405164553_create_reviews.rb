class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.integer :avaliation
      t.text :comment
      t.references :fix, foreign_key: true

      t.timestamps
    end
  end
end
