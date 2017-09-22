class Configuration < AbstractModel

  attr_reader :application, :period, :stakeholders, :postpone_for, :deploy_after, :deploy_before

  def initialize(application, configs)
    @application   = application
    @period        = configs['period']
    @stakeholders  = configs['stakeholders']
    @postpone_for  = configs['postpone_for']
    @deploy_after  = configs['deploy_after']
    @deploy_before = configs['deploy_before']
  end

end
