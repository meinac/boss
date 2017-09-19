class SCM

  def self.start
    ApplicationFactory.applications.each do |application|
      new(application).run
    end
  end

  attr_reader :application

  def initialize(application)
    @application = application
  end

  def run
    while(true) do
      application.init_file_system!
      application.create_release_candidate
      sleep(application.period)
    end
  end

  private
    def fetch
      Dir.mkdir(application.scm_path) if !Dir.exist?(application.scm_path)

      Dir.chdir(application.scm_path) do
        File.open('tmp.txt', 'w+') do |f|
          f << application.name
        end
      end
    end

end
