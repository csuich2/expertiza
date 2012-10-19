class CreateDocumentLinks < ActiveRecord::Migration
  def self.up
    create_table :submitted_content_links do |t|
      t.integer :participant_id
      t.string :hyperlink

      t.timestamps
    end
  end

  def self.down
    drop_table :submitted_content_links
  end
end
