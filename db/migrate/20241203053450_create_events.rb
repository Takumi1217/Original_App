class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :catchphrase
      t.text :body
      t.datetime :start_date
      t.datetime :end_date
      t.string :area
      t.string :place
      t.string :station
      t.string :category
      t.string :contact
      t.string :cost
      t.string :link
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :events, [:user_id, :created_at]
  end
end
