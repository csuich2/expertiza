class RenameDocumentLinkToSubmittedContentLink < ActiveRecord::Migration
  def self.up
    rename_table :document_links, :submitted_content_links
    rename_column :submitted_content_links, :user_id, :participant_id
  end

  def self.down
    rename_column :submitted_content_links, :participant_id, :user_id
    rename_table :submitted_content_links, :document_links
  end
end
