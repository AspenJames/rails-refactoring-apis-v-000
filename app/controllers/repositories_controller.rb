class RepositoriesController < ApplicationController
  def index
    s = GithubService.new({"access_token": session[:token]})
    @repos_array = s.get_repos
  end

  def create
    s = GithubService.new({"access_token": session[:token]})
    s.create_repo(params[:name])
    redirect_to '/'
  end
end
