require 'securerandom'

class AbstractModel
  include Serializable

  def id
    @id ||= SecureRandom.uuid
  end

end
