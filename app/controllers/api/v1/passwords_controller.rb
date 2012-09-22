class Api::V1::PasswordsController < Devise::PasswordsController
  def after_sending_reset_password_instructions_path_for(resource)
    "/"
  end
end
