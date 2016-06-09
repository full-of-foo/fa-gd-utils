require 'gooddata'

user_key       = 'GD_USERNAME'.freeze
pass_key       = 'GD_PASS'.freeze
tokens_csv_key = 'TOKENS_CSV_PATH'.freeze
fa_gd_server   = 'https://bi.fieldaware.com'.freeze
has_env_keys   = ENV.has_key?(user_key) and ENV.has_key?(pass_key) \
                   and ENV.has_key?(tokens_csv_key)

raise "[#{user_key},#{pass_key},#{tokens_csv_key}] required in ENV" unless has_env_keys


class Business
  attr_accessor :token, :name, :users
end

class Project
  attr_accessor :id, :name, :users
end


# 1. Read token CSV + some validation (first col cells should be all 12 chars)
# 2. Collect FA businesses + users
# 3. Collect GD projects
# 4. Enroll all unenroled users and delete all users on GD that do not correspond to a FA user



# GoodData.with_connection(login: ENV[user_key],
#                          password: ENV[pass_key],
#                          server: fa_gd_server) do |client|
#   puts "Fetching all projects..."
#   client.projects.each do |p|
#     puts p.id
#   end
# end
