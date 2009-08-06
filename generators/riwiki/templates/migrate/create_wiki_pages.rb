class CreateWikiPages < ActiveRecord::Migration

  def self.up
    create_table :wiki_pages do |t|
      t.integer :creator_id
      t.integer :updator_id
      
      t.string :path
      t.string :title
      
      t.text :content
          
      t.timestamps
    end
  end
  
  def self.down
    drop_table :wiki_pages
  end
  
end