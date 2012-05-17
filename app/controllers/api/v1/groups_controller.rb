class Api::V1::GroupsController < ApplicationController
  respond_to :json

  def index
    respond_with Group.all
  end
<<<<<<< HEAD
  
  def destroy
    Group.find(params[:id]).destroy
    redirect_to api_v1_groups_path
=======

  def create
    respond_with(Group.create(params[:group]), :location => "")
>>>>>>> 9d78a457f1a52e6832c2c3f4844570c0e5dc25e1
  end
end
