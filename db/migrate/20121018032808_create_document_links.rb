class CreateDocumentLinks < ActiveRecord::Migration
  def self.up
    create_table :document_links do |t|
      t.integer :user_id
      t.string :hyperlink

      t.timestamps
    end
  end

  def self.down
    drop_table :document_links
  end
end
