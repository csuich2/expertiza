class GoogleDocController < ApplicationController
  before_filter :check_participant

  def index
    # Create the list of provider auths for this user, if they have any
    @auths = ProviderAuth.find_all_by_user_id(@participant.user_id)
    # Make sure the user has google auth setup, otherwise we can't
    # access their Google Docs
    google_auth = false
    @auths.each do |entry|
      if entry.provider.titleize == "Google Oauth2"
        google_auth = true
      end
    end
    return unless google_auth

    # If the user searched or asked for recent docs
    if params[:title_search] || params[:list_count]
      # Build the Google Docs API Client
      client = build_client
      # Build the drive API object
      drive = build_drive(client)

      # If the user searched by the title, get those results
      if params[:title_search]
        # Replace any apostrophe's with "\'"
        search = params[:title_search].gsub(/\'/, "\\\\'")
        # Create the search query
        parameters = { 'q' => "title contains '#{search}'" }
        # Send the request to Google
        result = client.execute(:api_method => drive.files.list,
                                :parameters => parameters)
      # Otherwise the user requested some of their most recent docs, so get those results
      else params[:list_count]
        # Create the search query
        parameters = { 'maxResults' => params[:list_count] }
        # Send the request to Google
        result = client.execute(:api_method => drive.files.list,
                                :parameters => parameters)
      end

      # If the request was successful, get a result hash and set
      # it to a variable the view can access
      if result.status == 200
        @result_hash = result.data.to_hash
        @result_hash
      # If there was an error, display it
      else
        # TODO show the actual error
        flash[:error] = "File search failed."
      end
    end
  end

  def create
    # TODO why do I have to use @_params here? For some reason, just params doesn't work
    if @_params[:fileId] == nil || @_params[:link] == nil
      flash[:error] = "Could not submit Google Doc: Missing parameter!"
      redirect_to_index
      return
    end
    # Build the Google Docs API Client
    client = build_client
    # Build the drive API object
    drive = build_drive(client)
    # Retrieve a list of the file's permissions
    params = {
        'fileId' => @_params[:fileId],
    }
    result = client.execute(
        :api_method => drive.permissions.list,
        :parameters => params
    )
    # If there was an error, bail out
    if result.status != 200
      flash[:error] = "Unable to update permissions. #{result.data['error']['message']}"
      redirect_to_index
      return
    end
    permissions = result.data['items']
    permissions = permissions.select {|i| i['type'] == 'anyone'}
    # If there are no entries with 'type' = 'anyone', we need to create one.
    # Otherwise, we'll update the existing one
    if permissions.size == 0
      params = {
          'type' => 'anyone',
          'role' => 'reader',
          'value' => '',
          'additionalRoles' => ['commenter'],
          'withLink' => true,
      }
      result = client.execute(
          :api_method => drive.permissions.insert,
          :body_object => drive.permissions.insert.request_schema.new(params),
          :parameters => {'fileId' => @_params[:fileId]}
      )
    else
      params = {
          'role' => permissions[0]['role'],
          'additionalRoles' => ['commenter'],
      }
      result = client.execute(
          :api_method => drive.permissions.update,
          :body_object => drive.permissions.update.request_schema.new(params),
          :parameters => {'fileId' => @_params[:fileId], 'permissionId' => permissions[0]['id']}
      )
    end
    # If there was an error updating the permissions, redirect to the index and show an error
    if result.status != 200
      flash[:error] = "Unable to update permissions. #{result.data['error']['message']}"
      redirect_to_index
      return
    end
    # Now submit the link to the database
    @participant.submit_google_doc(@_params[:link])
    redirect_to :controller => 'submitted_content', :action => 'edit', :id => @_params[:participant_id]
  end

  private
  def check_participant
    # Get the participant from the passed participant_id
    @participant = AssignmentParticipant.find(params[:participant_id])
    # Get the user id from the participant
    @user_id = @participant.user_id
  end

  def redirect_to_index
    redirect_to :action => 'index', :participant_id => params[:participant_id]
  end

  def build_client
    authEntry = ProviderAuth.all(:conditions => "user_id = #{@user_id}").first
    client = Google::APIClient.new
    client.authorization.client_id = authEntry.access_token #saving token in client_id to maintain uniqueness
    client.authorization.scope = "https://docs.google.com/feeds/"
    client.authorization.access_token = authEntry.access_token
    client
  end

  def build_drive(client)
    client.discovered_api('drive', 'v2')
  end
end
