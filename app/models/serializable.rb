module Serializable

  attr_reader :updated_at

  def self.included(base)
    base.extend(ClassMethods)
  end

  def reload
    raw_data = Database.read_model(self.class, id)

    Marshal.load(raw_data)
  end

  def save
    raw_data = Marshal.dump(self)

    Database.write_model(self.class, id, raw_data)
  end

  def touch
    @updated_at = Time.now
    save
  end

  module ClassMethods

    def all
      raw_data = Database.read_all(self)

      raw_data.map do |app_data|
        Marshal.load(app_data)
      end
    end

  end

end
