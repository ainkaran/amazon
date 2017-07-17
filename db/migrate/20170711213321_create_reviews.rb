class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.references :product, foreign_key: true, index: true
      t.text :body
      t.integer :rating

      t.timestamps
    end
  end
end
