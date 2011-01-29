class CreateWikiPageAttachments < ActiveRecord::Migration

  def self.up
    create_table :wiki_page_attachments do |t|
      t.integer :page_id, :null => false # Reference to page
      t.string   :wiki_page_attachment_file_name
      t.string   :wiki_page_attachment_content_type
      t.integer  :wiki_page_attachment_file_size

      t.timestamps
    end

  end

  def self.down
    drop_table :wiki_page_attachments
  end

end
