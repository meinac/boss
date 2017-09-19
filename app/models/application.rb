class Application
  attr_reader :name, :period, :stakeholders, :postpone_for, :deploy_after, :deploy_before, :changes, :repository

  def initialize(app_name, configs)
    @name          = app_name
    @period        = configs['period']
    @stakeholders  = configs['stakeholders']
    @postpone_for  = configs['postpone_for']
    @deploy_after  = configs['deploy_after']
    @deploy_before = configs['deploy_before']
    @repository    = Repository.new(self, configs['repository'], configs['branch'])

    init_file_system!
  end

  def path
    "tmp/#{name}"
  end

  def init_file_system!
    FS.mkdir(path)
    repository.init_file_system!
  end

  def create_release_candidate
    repository.create_release_candidate
  end

end
