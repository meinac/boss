class Application < AbstractModel
  attr_reader :name, :configuration, :repository, :releases

  def initialize(app_name, configs)
    @name = app_name

    create_children(configs)
    init_file_system!
  end

  alias_method :id, :name

  def path
    "tmp/#{name}"
  end

  def init_file_system!
    FS.mkdir(path)
  end

  def create_release_candidate
    release = Release.new(self, next_release_version)
    return if release.is_empty?

    release.note.save
    releases << release
  end

  def next_release_version
    releases.last&.version.to_i + 1
  end

  private
    def create_children(configs)
      @configuration = Configuration.new(self, configs)
      @releases      = []
      @repository    = Repository.new(self, configs['repository'], configs['branch'])
    end

end
