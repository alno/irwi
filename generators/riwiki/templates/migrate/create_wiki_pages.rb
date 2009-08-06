class CreateWikiPagesMigration < ActiveRecord::Migration

  def self.up
    create_table :wiki_pages do |t|
      t.integer :created_by
      t.integer :updated_by
      
      t.string :title
      
      t.text :content
          
      t.timestamps
    end
  end
  
  def self.down
    drop_table :wiki_pages
  end
  
end