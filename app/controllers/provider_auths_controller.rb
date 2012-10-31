require 'google/api_client'

class ProviderAuthsController < ApplicationController
  before_filter :authorize
  skip_before_filter :goldberg_security_filter

  def index
    @auths = ProviderAuth.all
  end

  def create
    @user_id = session[:user].id
    # save the hash returned by omniauth
    auth = request.env["omniauth.auth"]
    @provider_auth = ProviderAuth.create_authEntry(auth, @user_id)
    redirect_to "/submitted_content/edit/#{request.env["omniauth.params"]["id"]}"
  end

  def destroy
    @provider_auth = current_user.provider_auths.find(params[:id])
    @provider_auth.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to provider_auths_path
  end

  def failure
    render :text => request.env["omniauth.auth"].to_yaml rescue "Provider failed to authenticate"
  end

end

