class Application
  attr_reader :name, :period, :stakeholders, :postpone_for, :deploy_after, :deploy_before, :changes, :repository, :releases

  def initialize(app_name, configs)
    @name          = app_name
    @period        = configs['period']
    @stakeholders  = configs['stakeholders']
    @postpone_for  = configs['postpone_for']
    @deploy_after  = configs['deploy_after']
    @deploy_before = configs['deploy_before']
    @releases      = []
    @repository    = Repository.new(self, configs['repository'], configs['branch'])

    init_file_system!
  end

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

end
