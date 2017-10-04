class Author
  attr_reader :commit, :name, :email

  def initialize(commit, name, email)
    @commit = commit
    @name   = name
    @email  = email
  end

  # lol
  def is_notifiable?
    (whitelisted_regex &&
      (email =~ whitelisted_regex || whitelisted_list.to_a.include?(email))) ||
        (!whitelisted_regex &&
          (!whitelisted_list || whitelisted_list.include?(email)))
  end

  # This method is used by Array#uniq
  # method of Ruby core.
  def hash
    "Author::#{email}".hash
  end

  def ==(other)
    other.respond_to?(:email) && email == other.email
  end

  alias_method :eql?, :==
  alias_method :eq?, :==

  private
    def whitelisted_regex
      Regexp.new(application_config.whitelisted_authors_regex) if application_config.whitelisted_authors_regex
    end

    def whitelisted_list
      application_config.whitelisted_authors
    end

    def application_config
      @application_config ||= commit.release.application.configuration
    end

end
