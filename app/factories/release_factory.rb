class ReleaseFactory

  class << self
    def create(application, version)
      release = Release.new(application, version)
      return if release.is_empty?

      release.note.save
      release
    end
  end

end
