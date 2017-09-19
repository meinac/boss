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

    def open_file(file_name, options = nil, mode = 0644, &block)
      File.open(file_name, options, mode) { |f| block.call(f) }
    end
  end

end
