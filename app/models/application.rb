class Application < AbstractModel
  attr_reader :name
  attr_accessor :configuration, :repository

  def initialize(app_name)
    @name = app_name

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
    release = ReleaseFactory.create(self, next_release_version)
    releases << release if release
  end

  def next_release_version
    releases.last&.version.to_i + 1
  end

  def releases
    @releases ||= []
  end

end
