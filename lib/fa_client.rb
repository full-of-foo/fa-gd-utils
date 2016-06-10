require "rest-client"


module FAClient
  CLIENT = RestClient::Resource.new("https://api.fieldaware.net")
  DEFAULT_PAGE_SIZE = 100

  def self.get_resource(path, token)
    puts "Fetching #{path}: #{token}"
    JSON.parse(CLIENT[path].get(Authorization: "Token #{token}"))
  end

  def self.get_business(token)
    puts "Fetching business: #{token}"
    self.get_resource("business", token)
  end

  def self.get_users(token)
    puts "Fetching users: #{token}"
    res = CLIENT["user/"].get Authorization: "Token #{token}",
                              params: { pageSize: DEFAULT_PAGE_SIZE, archived: false }
    uuids = collection_response_uuids(res)
    # TODO - respect pagination

    uuids.map { |uuid| self.get_resource("user/#{uuid}", token) }
  end

  def self.collection_response_uuids(res)
    JSON.parse(res)['items'].map { |u| u['link']['url'].split('/').last }
  end
  private_class_method :collection_response_uuids

end
