class CreateCaptions < ActiveRecord::Migration[8.1]
  def change
    create_table :captions do |t|
      t.string :url
      t.string :text
      t.string :caption_url

      t.timestamps
    end
  end
end
