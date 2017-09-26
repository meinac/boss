class Database

  PATH = 'tmp/db'

  class << self
    def read_model(model, id)
      init_data_file!(model, id)

      FS.read_file(data_file(model, id))
    end

    def write_model(model, id, data)
      init_data_file!(model, id)

      FS.open_file(data_file(model, id), 'w') { |f| f << data }
    end

    def read_all(model)
      ensure_path_exists!(model)
      model_path = model_path(model)

      FS.list(model_path).map do |file|
        FS.read_file("#{model_path}/#{file}") unless file =~ /^\./
      end.compact
    end

    private
      def model_path(model)
        "#{PATH}/#{model.to_s.underscore}"
      end

      def data_file(model, id)
        "#{model_path(model)}/#{id}.data"
      end

      def init_data_file!(model, id)
        file_name = data_file(model, id)
        return if FS.exist?(file_name)

        ensure_path_exists!(model)
        FS.create(file_name)
      end

      def ensure_path_exists!(model)
        FS.mkdir(PATH)
        FS.mkdir(model_path(model))
      end

  end

end
