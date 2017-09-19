class Git

  class << self
    def clone(repository)
      `git clone #{repository} ./`
    end

    def pull(branch)
      `git pull origin #{branch}`
    end

    def create_branch(branch)
      `git checkout -b #{branch}`
    end

    def checkout(branch)
      `git checkout #{branch}`
    end

    def rebase(branch)
      `git rebase #{branch}`
    end

    def get_url
      `git remote get-url origin`
    end

    def log_between(from_branch, to_branch)
      `git log --no-merges #{from_branch}..#{to_branch}`
    end
  end

end
