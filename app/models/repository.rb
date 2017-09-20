class Repository
  attr_reader :application, :remote_url, :branch

  def initialize(application, remote_url, branch)
    @application = application
    @remote_url  = remote_url
    @branch      = branch

    init_file_system!
  end

  def path
    "#{application.path}/scm"
  end

  def init_file_system!
    application.init_file_system!

    return if repository_initalized?

    FS.run_in_dir(path) { Git.clone(remote_url) }
  end

  # Returns git log between two branches;
  # First one is the base branch and the
  # second one is the given branch_name.
  def changes_on(branch_name)
    FS.run_in_dir(path) do
      create_relase_branch(branch_name)
      log = Git.log_between(branch, branch_name)
      rebase_branch_from(branch_name)
      log
    end
  end

  private
    def repository_initalized?
      FS.mkdir(path)

      FS.run_in_dir(path) do
        remote_url == Git.get_url
      end
    end

    def create_relase_branch(branch_name)
      Git.create_branch(branch_name)
      Git.pull(branch)
    end

    def rebase_branch_from(branch_name)
      Git.checkout(branch)
      Git.rebase(branch_name)
    end

end
