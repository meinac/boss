class Configuration < AbstractModel
  ATTRIBUTES = [
    :period,
    :stakeholders,
    :whitelisted_authors,
    :whitelisted_authors_regex,
    :postpone_for,
    :deploy_after,
    :deploy_before
  ]

  attr_reader *ATTRIBUTES

  def initialize(configs)
    ATTRIBUTES.each do |attribute|
      instance_variable_set("@#{attribute}", configs[attribute.to_s])
    end
  end

end
