class Util

  class << self
    def put_log(message, level = :info)
      logger.send(level, message)
    end

    private
      def logger
        @logger ||= Logger.new(log_file)
      end

      def log_file
        file = $app_config.daemon && $app_config.logfile || STDOUT
      end

  end

end
