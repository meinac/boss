class CommitFactory
  COMMIT_REGEX = /commit\s(.+)$\n^author:\s(.+)$\n^date:\s(.+)$\n((?:\s\n*.+\n*)+)\s?(?=commit)?/i

  class << self
    def create_list(release)
      release.git_changes.scan(COMMIT_REGEX).map do |match|
        Commit.new(release, match[0], match[1], match[2], match[3]).tap do |commit|
          commit.author = AuthorFactory.create(commit)
        end
      end
    end
  end

end
