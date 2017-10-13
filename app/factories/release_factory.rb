class ReleaseFactory

  class << self
    def create(application)
      release = Release.new(application)
      return if release.is_empty?

      release.note.save
      release
    end
  end

end
