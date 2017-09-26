class AuthorFactory
  AUTHOR_REGEX = /(.+)\s<(.+)>/i

  class << self
    def create(commit)
      name, email = parse_commit_author(commit.git_author)

      Author.new(commit, name, email)
    end

    private
      def parse_commit_author(commit_author)
        match_data = commit_author.match(AUTHOR_REGEX).to_a
        match_data[1..2]
      end

  end

end
