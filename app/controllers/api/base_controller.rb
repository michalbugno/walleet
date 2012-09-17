class Api::BaseController < ApplicationController
  before_filter :authenticate_person!

  def authenticate_person!
    api_token = request.headers["X-Api-Token"]
    if api_token
      person = Person.find_by_api_token(api_token)
      if person
        sign_in(person)
      else
        return render :status => 401, :nothing => true
      end
    else
      super
    end
  end
end
