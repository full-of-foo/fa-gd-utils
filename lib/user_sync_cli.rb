require "gooddata"
require "thor"
require "yaml"
require "csv"
require "./lib/fa_client"


class Business
  attr_accessor :name, :token, :users

  def initialize(token)
    @token = token
  end

  def gd_name
    @name + " (PRODUCTION)"
  end
end


class UserSyncCLI < Thor

  desc "enroll USER PROJECT_ID", "enrolls USER to PROJECT"
  def enroll_user(email, project_id)
    enroll_user_on_project(email, project_id)
  end

  desc "unenroll USER PROJECT_ID", "unenrolls USER to PROJECT"
  def unenroll_user(email, project_id)
    deactivate_user_on_project(email, project_id)
  end

  desc "Synchronise users", "Synchronise whitelisted FA users with GD"
  def sync_users
    # businesses = collect_businesses
    projects = collect_projects
    projects.each {|p| puts p.title}

    # businesses.each do |biz|
    #   matching_projs = projects.select { |p| p.title == biz.gd_name }
    #   puts biz.name, matching_projs.size
    #
    #
    #
    # end
  end

  private
    def client
      @client ||= GoodData.connect(YAML.load(File.read('gd_credentials.yml')))
    end

    def tokens
      @tokens ||= CSV.read(ENV['TOKENS_CSV_PATH']).map {|row| row[0]}
    end

    def collect_businesses
      businesses = []
      tokens.each do |token|
        biz = Business.new(token)
        biz.name = FAClient.get_business(biz.token)['name']
        biz.users = FAClient.get_users(biz.token)
        businesses << biz
      end
      businesses
    end

    def collect_projects
      client.projects.pselect { |p| p.am_i_admin? && p.title.end_with?(" (PRODUCTION)") }
    end

    def enroll_user_on_project(email, project_id)
      project = GoodData.use(project_id)
      is_on_project = project.member?(email)
      puts "#{email} already on #{project.title}: #{is_on_project}"
      if not is_on_project
        project.add_user(email, 'Editor')
        puts "#{email} now on #{project.title}: #{is_on_project}"
      end
    end

    def deactivate_user_on_project(email, project_id)
      project = GoodData.use(project_id)
      is_on_project = project.member?(email)
      puts "#{email} already on #{project.title}: #{is_on_project}"
      if is_on_project
        project.member(email).disable
        puts "#{email} now on #{project.title}: #{is_on_project}"
      end
    end

end
