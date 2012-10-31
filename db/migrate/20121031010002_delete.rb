class Delete < ActiveRecord::Migration
  def self.up
    remove_column :participants, :submitted_google_docs
  end

  def self.down
    add_column :participants, :submitted_google_docs
  end
end
