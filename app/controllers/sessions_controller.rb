class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: :create

  def create
    s = GithubService.new
    s.authenticate!(ENV["GITHUB_CLIENT"], ENV["GITHUB_SECRET"], params[:code])

    session[:token] = s.access_token

    session[:username] = s.get_username

    redirect_to '/'
  end
end
