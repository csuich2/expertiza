class CreateProviderAuths < ActiveRecord::Migration
  def self.up
    create_table :provider_auths do |t|
      t.column "user_id", :integer
      t.column "provider", :string
      t.column "uid", :string
      t.column "access_token", :string
      t.column "refresh_token", :string
      t.column "expires", :integer

      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
  end

  def self.down
    drop_table "provider_auths"
  end
end
