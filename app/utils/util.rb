class Util

  class << self
    def put_log(message, level = :info)
      logger.send(level, message)
    end

    private
      def logger
        @logger ||= Logger.new($app_config.logfile || STDOUT)
      end

  end

end
