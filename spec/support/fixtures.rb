module Fixtures
  # fixture :application
  # fixture :application, :rails
  # fixture :application, name: :rails
  # fixture :application, :rails, name: :rails
  def fixture(*args)
    model, fixture, extra = parse_given_args(args)
    model_data     = load_model_file(model)
    fixture_data   = model_data[fixture.to_s]

    instantiate_model(model, fixture_data, extra)
  end

  private
    def load_model_file(fixture_name)
      YAML.load_file("spec/fixtures/#{fixture_name}.yml")
    rescue Errno::ENOENT
      raise "No fixture file found for #{fixture_name}"
    end

    def parse_given_args(args)
      name, opts = (args[1].respond_to?(:keys) ? args[0..1] : args[1..2])
      [args[0], name || args[0], opts || {}]
    end

    def instantiate_model(model, data, **extra)
      model.to_s.classify.constantize.allocate.tap do |object|
        data.each do |variable_name, value|
          value_to_set = extra.fetch(variable_name.to_sym, value)
          set_data_on(object, variable_name, value_to_set)
        end
      end
    end

    # If the variable name ends with @ this means
    # the variable should be resolved as fixture
    def set_data_on(object, variable_name, value)
      if variable_name.end_with?('@')
        relation_name = variable_name[0...-1]

        object.instance_variable_set("@#{relation_name}", fixture(value))
      else
        object.instance_variable_set("@#{variable_name}", value)
      end
    end

end
