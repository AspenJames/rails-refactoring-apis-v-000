class GithubService
  attr_accessor :access_token

  def initialize(access_hash = nil)
    @access_token = access_hash["access_token"] || access_hash[:access_token] if access_hash
  end

  def authenticate!(client_id, client_secret, code)
    resp = Faraday.post("https://github.com/login/oauth/access_token") do |req|
      req.headers = {"Accept": "application/json", "Content-Type": "application/json"}
      req.body = "{\"client_id\": \"#{client_id}\", \"client_secret\": \"#{client_secret}\", \"code\": \"#{code}\"}"
    end
    @access_token = JSON.parse(resp.body)["access_token"]
  end

  def get_username
    resp = Faraday.get("https://api.github.com/user") do |req|
      req.headers = {"Accept": "application/json", "Authorization": "token #{self.access_token}"}
    end
    JSON.parse(resp.body)["login"]
  end

  def get_repos
    resp = Faraday.get("https://api.github.com/user/repos") do |req|
      req.headers = {"Accept": "application/json", "Authorization": "token #{self.access_token}"}
    end
    repos = []
    JSON.parse(resp.body).each do |repo_hash|
      repos << GithubRepo.new(repo_hash)
    end
    repos
  end

  def create_repo(name)
    resp = Faraday.post("https://api.github.com/user/repos") do |req|
      req.headers = {"Accept": "application/json", "Authorization": "token #{self.access_token}"}
      req.body = {name: name}.to_json
    end
  end
end
