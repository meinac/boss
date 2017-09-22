class FS

  class << self
    def run_in_dir(dir, &block)
      current_dir = Dir.getwd

      Dir.chdir(dir) do
        block.call
      end
    ensure
      Dir.chdir(current_dir)
    end

    # This is different than the Ruby's Dir.mkdir,
    # it does not raise exception if the path is
    # already created.
    def mkdir(path)
      return if Dir.exist?(path)

      Dir.mkdir(path)
    end

    def list(path)
      Dir.entries(path)
    end

    def open_file(file_name, options = nil, mode = 0644, &block)
      File.open(file_name, options, mode) { |f| block.call(f) }
    end

    def read_file(file_name)
      File.read(file_name)
    end

    def exist?(file_name)
      File.exist?(file_name)
    end

    def create(file_name, mode = 0644)
      File.new(file_name, File::CREAT, mode)
    end
  end

end
