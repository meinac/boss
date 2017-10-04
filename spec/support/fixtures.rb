module Fixtures
  # fixture :application
  # fixture :application, :rails
  # fixture :application, name: :rails
  # fixture :application, :rails, name: :rails
  def fixture(*args)
    model, fixture, extra, except = parse_given_args(args)
    model_data     = load_model_file(model)
    fixture_data   = model_data[fixture.to_s]

    instantiate_model(model, fixture_data, extra, except)
  end

  private
    def load_model_file(fixture_name)
      YAML.load_file("spec/fixtures/#{fixture_name}.yml")
    rescue Errno::ENOENT
      raise "No fixture file found for #{fixture_name}"
    end

    def parse_given_args(args)
      name, opts = (args[1].respond_to?(:keys) ? args[0..1] : args[1..2])
      except = [(opts || {}).delete(:except!)].flatten.compact.map(&:to_sym)
      [args[0], name || args[0], opts || {}, except]
    end

    def instantiate_model(model, data, extra, except)
      model.to_s.classify.constantize.allocate.tap do |object|
        data.each do |variable_name, value|
          value_to_set = YAML.load(value.to_s)
          set_data_on(model, object, variable_name, value_to_set, except)
        end

        extra.each do |variable_name, value|
          set_data_on(model, object, variable_name.to_s, value, except)
        end
      end
    end

    # If the variable name ends with @ this means
    # the variable should be resolved as fixture
    def set_data_on(model, object, variable_name, value, except)
      if variable_name.end_with?('@')
        relation_name = variable_name[0...-1]
        return if except.include?(relation_name.to_sym)

        object.instance_variable_set("@#{relation_name}", fixture(value, except!: model))
      else
        object.instance_variable_set("@#{variable_name}", value)
      end
    end

end
