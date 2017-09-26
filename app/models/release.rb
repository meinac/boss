class Release < AbstractModel
  RELEASE_SERIALIZATION_PATTERN = '%Y_%m_%d_%H_%M_%S'
  RELEASE_NAME_PATTERN          = '%Y/%m/%d %H:%M'

  attr_reader :application, :version, :deployed, :created_at

  def initialize(application, version)
    @application = application
    @version     = version
    @deployed    = false
    @created_at  = Time.now
  end

  def name
    @name ||= "#{application.name} (#{version} - #{created_at.strftime(RELEASE_NAME_PATTERN)})"
  end

  def serialization_name
    @serialization_name ||= created_at.strftime(RELEASE_SERIALIZATION_PATTERN)
  end

  def commits
    @commits ||= CommitFactory.create_list(self)
  end

  def authors
    commits.map(&:author)
  end

  def note
    @note ||= Note.new(self)
  end

  def path
    "#{application.path}/releases"
  end

  def init_file_system!
    FS.mkdir(path)
  end

  def is_empty?
    commits.blank?
  end

  def git_changes
    application.repository.changes_on(serialization_name)
  end

end
