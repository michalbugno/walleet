class Api::V1::RegistrationsController < Devise::RegistrationsController
  def create
    super
    if !resource.new_record?
      Mailer.welcome(resource).deliver
    end
  end
end
