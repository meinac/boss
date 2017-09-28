class Commit < AbstractModel
  DATE_PATTERN = '%Y-%m-%d %H:%M'
  HOTFIX_REGEX = /<<hotfix>>/i

  attr_reader :release, :hash, :git_author, :date, :message
  attr_accessor :author

  def initialize(release, hash, git_author, date, message)
    @release    = release
    @hash       = hash
    @git_author = git_author
    @date       = date
    @message    = message
  end

  def pretty_date
    @pretty_date ||= DateTime.parse(date).strftime(DATE_PATTERN)
  end

  def is_hotfix?
    message =~ HOTFIX_REGEX
  end

end
