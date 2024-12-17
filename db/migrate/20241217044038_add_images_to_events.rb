class AddImagesToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :thumbnail, :string
    add_column :events, :image_1, :string
    add_column :events, :image_2, :string
  end
end
