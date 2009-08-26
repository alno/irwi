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
    
    create_table :wiki_page_versions do |t|
      t.integer :page_id # Reference to page      
      t.integer :updator_id # Reference to user, updated page
      
      t.integer :number # Version number
      
      t.string :comment
      
      t.string :path
      t.string :title
      
      t.text :content
          
      t.timestamp :updated_at
    end
  end
  
  def self.down
    drop_table :wiki_page_versions
    drop_table :wiki_pages
  end
  
end