class CLI

  PID_FILE = File.expand_path('tmp/worker.pid')

  class << self
    def start
      check_pid_file!

#      Process.daemon(true, false)
      set_pid_file

      at_exit do
        remove_pid_file
      end

      start_workers
    end

    def stop
      if !File.exist?(PID_FILE)
        puts "It looks like boss is already stopped!"
        return
      end

      pid = File.read(PID_FILE).split("\n").first

      puts "Killing process with ID #{pid}"

      # Instead of checking the process ID with `ps`
      # we need to explicitly check our PID file to
      # prevent race conditions!
      `
        kill #{pid}
        while [ -f #{PID_FILE} ]; do
          sleep 1
        done
      `

      puts "Boss has been stopped"
    end

    def restart
      stop && start
    end


    private
      def check_pid_file!
        if File.exist?(PID_FILE)
          puts "It seems like boss is already running!\nPlease check the pid file!"
          exit 1
        end
      end

      def remove_pid_file
        File.delete(PID_FILE) if File.exist?(PID_FILE)
      end

      def set_pid_file
        File.open(PID_FILE, 'w+') do |f|
          f.puts Process.pid
        end
      end

      def start_workers
        SCM.start
      end

  end

end
