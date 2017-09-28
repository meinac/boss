class ApplicationFactory

  class << self
    def applications
      @applications ||= create_applications
    end

    def persist_applications
      applications.each(&:save)
    end

    private
      def create_applications
        $app_config.applications.map do |app_name, configs|
          (persisted_application(app_name) || Application.new(app_name)).tap do |application|
            application.configuration = create_configuration(configs)
            application.repository    = create_repository(application, configs)
          end
        end
      end

      def create_configuration(configs)
        Configuration.new(configs)
      end

      def create_repository(application, configs)
        Repository.new(application, configs['repository'], configs['branch'])
      end

      def persisted_application(app_name)
        Application.all.select { |app| app_name == app.name }.first
      end

  end

end
