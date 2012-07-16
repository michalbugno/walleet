class Api::V1::PeopleController < Api::BaseController
  respond_to :json

  def show
    respond_with(current_person)
  end
end
