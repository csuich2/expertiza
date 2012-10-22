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
      authEntry.expires = auth['credentials']['expires_at']
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
    auths = self.get_google_oauth_for_user(user_id)
    if auths.size > 0
      return true
    else
      return false
    end
  end

  def self.get_google_oauth_for_user(user_id)
    auths = ProviderAuth.all(:conditions => "user_id = #{user_id} AND provider='google_oauth2'")

    validAuths = [];
    auths.each do |entry|
      if Time.now >= Time.at(entry.expires)
        entry.destroy
      else
        validAuths << entry
      end
    end
    return validAuths
  end
end
