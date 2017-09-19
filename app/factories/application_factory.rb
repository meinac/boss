class ApplicationFactory

  class << self
    def applications
      @applications ||= create_applications
    end

    private
      def create_applications
        $app_config.applications.map do |app_name, configs|
          Application.new(app_name, configs)
        end
      end
  end

end
