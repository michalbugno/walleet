class Api::V1::ApisController < Api::BaseController
  skip_before_filter :authenticate_person!
  respond_to :json

  def show
    apis = [
      api_entry(:post, "person", "Create an account (required params: {person: {email: 'email@example.com', password: 'pass'}}"),
      api_entry(:post, "person/sign_in", "Show account using email/password"),
      api_entry(:get, "person", "Show your account"),
      api_entry(:get, "person/feed", "Show your account's feed"),
      api_entry(:get, "groups", "List of groups"),
      api_entry(:get, "groups/1", "Show group with id=1"),
      api_entry(:put, "groups/1", "Edit group with id=1"),
      api_entry(:delete, "groups/1", "Remove group with id=1"),
      api_entry(:get, "groups/1/feed", "Activity feed for group"),
      api_entry(:post, "groups", "Create a group (required parameter: 'name'"),
      api_entry(:post, "memberships", "Add a member to group (required params: 'group_id' and one of: 'person_id', 'email', 'name')"),
      api_entry(:delete, "memberships/1", "Remove person from group (identified by membership with id=1)"),
      api_entry(:post, "debts", "Add a debt (required params: 'giver_id' - membership of a person who paid for something, 'taker_ids' - comma-separated membership ids of people who took the money, 'amount' - in float, 'description')"),
    ]

    render :json => apis, :status => 200
  end

  private
  def api_entry(http_method, path, description)
    http_method = http_method.to_s.upcase
    path = File.join("/", "api", "v1", path) + ".json"
    {
      :method => http_method,
      :path => path,
      :description => description,
    }
  end

end
