class Git

  class << self
    def clone(repository)
      `git clone #{repository} ./ 2>&1`
    end

    def pull(branch)
      `git pull origin #{branch} 2>&1`
    end

    def create_branch(branch)
      `git checkout -b #{branch} 2>&1`
    end

    def checkout(branch)
      `git checkout #{branch} 2>&1`
    end

    def rebase(branch)
      `git rebase #{branch} 2>&1`
    end

    def get_url
      `git remote get-url origin 2>&1`
    end

    def log_between(from_branch, to_branch)
      `git log --no-merges #{from_branch}..#{to_branch}`
    end

    def commit(commit_message)
      `git commit -m '#{commit_message}' --allow-empty`
    end

    def reset(step)
      `git reset --hard HEAD~#{step}`
    end
  end

end
