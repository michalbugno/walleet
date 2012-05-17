class Api::V1::GroupsController < ApplicationController
  respond_to :json

  def index
    respond_with Group.all
  end

  def create
    respond_with(Group.create(params[:group]), :location => "")
  end
end
