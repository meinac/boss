require 'mail'

options = {
  address:               $app_config.mail.smtp_server,
  port:                  $app_config.mail.port,
  domain:                $app_config.mail.domain,
  user_name:             $app_config.mail.user_name,
  password:              $app_config.mail.password,
  authentication:        $app_config.mail.authentication,
  enable_starttls_auto:  $app_config.mail.enable_starttls_auto
}

Mail.defaults do
  delivery_method :smtp, options
end
