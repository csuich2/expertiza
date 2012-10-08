class AddGoogleDocsToParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :submitted_google_docs, :text
  end

  def self.down
    remove_column :participants, :submitted_google_docs, :text
  end
end
