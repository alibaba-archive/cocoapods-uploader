require 'yaml'

module Pod
  class Setting
    attr_accessor :host, :repo, :user, :password, :suffix

    def initialize(parameters={})
        parameters = {'suffix'=>"/artifactory/service/local/repositories/+repo+/content/"}.merge(parameters)
        @host   = parameters['host']
        @repo     = parameters['repo']
        @user     = parameters['user']
        @password = parameters['password']
        @suffix   = parameters['suffix']
    end

    def open
      path = "#{Pod::Config.instance.home_dir}/maven.yml"
      if File.exist?(path)
        config = YAML.load_file(path)
        @host = config['host']
        @repo = config['repo']
        @user = config['user']
        @password = config['password']
        @suffix = config['suffix']
      end
    end

    def save
      path = "#{Pod::Config.instance.home_dir}/maven.yml"
      
      File.open(path, "w+") do |file|
        config = {'host'=>host,'repo'=>repo,'user'=>user,'password'=>password,'suffix'=>suffix}
        file.puts(config.to_yaml)
      end
    end

    def to_hash
      hash = {}
      hash['host']        = host
      hash['repo']        = repo
      hash['user']        = user
      hash['password']    = password
      hash['suffix']      = suffix
      hash
    end

    def == other
      to_hash == other.to_hash
    end


  end
end
