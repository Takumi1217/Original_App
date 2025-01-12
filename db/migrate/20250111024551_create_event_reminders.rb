class CreateEventReminders < ActiveRecord::Migration[7.0]
  def change
    create_table :event_reminders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :title
      t.text :body
      t.datetime :published_at

      t.timestamps
    end
  end
end
