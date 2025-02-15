class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :url, null: false
      t.string :title
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.string :currency
      t.string :brand
      t.string :website
      t.jsonb :additional_info
      t.datetime :last_scraped_at
      t.string :status
      t.text :error_message
      
      t.timestamps
    end

    add_index :products, :url, unique: true
  end
end
