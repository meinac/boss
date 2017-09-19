class Release
  RELEASE_PATTERN = '%Y_%m_%d_%H_%M_%S'

  attr_reader :repository, :name, :commits, :deployed

  def initialize(repository, commits = [], deployed = false)
    @repository = repository
    @commits    = commits
    @deployed   = deployed
    @name       = Time.now.strftime(RELEASE_PATTERN)
  end

  def commits
    @commits ||= Commit.list_from_git_log(git_changes)
  end

  def release_note
    commits
  end

  private
    def git_changes
      repository.changes_on(name)
    end

end
