class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.integer :user_id
      t.string :title
      t.boolean :privacy

      t.timestamps
    end
    add_index :songs, :user_id 

  end
end
