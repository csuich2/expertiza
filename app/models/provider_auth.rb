class ProviderAuth < ActiveRecord::Base
  belongs_to :user

  def self.create_authEntry(auth, id)

    # if not found, create and save authentication
    # search for existing authentication entry with matching provider and uid
    authEntry = ProviderAuth.find_by_provider_and_uid(auth['provider'], auth['uid'])

    if authEntry.nil?
      authEntry = ProviderAuth.new
      authEntry.provider = auth['provider']
      authEntry.uid = auth['uid']
      authEntry.access_token = auth['credentials']['token']
      authEntry.refresh_token = auth['credentials']['refresh_token']
      authEntry.user_id = id
      authEntry.save
    else
      # else just update the token
      authEntry.access_token = auth['credentials']['token']
      authEntry.refresh_token = auth['credentials']['refresh_token']
      authEntry.save
    end
  end

  def self.user_has_google_auths?(user_id)
    # Get all the provider auths for the specified user
    auths = ProviderAuth.find_all_by_user_id(user_id)
    # Loop through all the auths and return true if we find a Google Oauth2 entry
    auths.each do |entry|
      if entry.provider.titleize == "Google Oauth2"
        return true
      end
    end
    return false
  end

  def self.get_google_oauth_for_user(user_id)
    authEntry = ProviderAuth.all(:conditions => "user_id = #{user_id} AND provider='google_oauth2'").first
  end
end
