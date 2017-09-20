class Commit
  COMMIT_REGEX = /commit\s(.+)$\n^author:\s(.+)$\n^date:\s(.+)$\n((?:\s\n*.+\n*)+)\s?(?=commit)?/i
  DATE_PATTERN = '%Y-%m-%d %H:%M'
  HOTFIX_REGEX = /<<hotfix>>/i

  attr_reader :hash, :author, :date, :message

  def initialize(hash, author, date, message)
    @hash    = hash
    @author  = author
    @date    = date
    @message = message
  end

  def pretty_date
    @pretty_date ||= DateTime.parse(date).strftime(DATE_PATTERN)
  end

  def is_hotfix?
    message =~ HOTFIX_REGEX
  end

  def self.list_from_git_log(git_log)
    git_log.scan(COMMIT_REGEX).map do |match|
      new(match[0], match[1], match[2], match[3])
    end
  end

end
