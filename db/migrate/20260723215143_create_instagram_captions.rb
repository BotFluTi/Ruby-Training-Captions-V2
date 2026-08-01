class CreateInstagramCaptions < ActiveRecord::Migration[8.1]
  def change
    create_table :instagram_captions do |t|
      t.string :url
      t.string :type
      t.string :text
      t.string :filter
      t.string :color
      t.string :start_color
      t.string :end_color
      t.string :caption_url

      t.timestamps
    end
  end
end
