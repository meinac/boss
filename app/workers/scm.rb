class SCM

  def self.start
    worker_threads = ApplicationFactory.applications.map do |application|
      Thread.new { new(application).run }
    end

    worker_threads.map(&:join)
  end

  attr_reader :application

  def initialize(application)
    @application = application
  end

  def run
    Util.put_log("SCM running for #{application.name}")

    while(true) do
      application.init_file_system!
      application.create_release_candidate
      sleep(application.configuration.period)
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
