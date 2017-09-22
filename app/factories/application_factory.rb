class ApplicationFactory

  class << self
    def applications
      @applications ||= create_applications
    end

    def persist_applications
      applications.each(&:save)
    end

    private
      # This is not good
      def create_applications
        applications_persisted = Application.all

        $app_config.applications.map do |app_name, configs|
          application = applications_persisted.select { |app| app_name == app.name }.first

          if application
            application.instance_variable_set(:@configuration, Configuration.new(application, configs))
            application
          else
            Application.new(app_name, configs)
          end
        end
      end

  end

end
