class Api::V1::GroupsController < ApplicationController
  respond_to :json

  def index
    respond_with Group.all
  end

  def create
    respond_with(Group.create(params[:group]), :location => "")
  end
  
  def add_person
    respond_with(Group.find(params[:id]).persons << Person.find(params[:person_id]), :location => "")
  end

  def remove_person
    respond_with(Group.find(params[:id]).group_memberships.where(:person_id => params[:person_id]).each { |el| el.destroy })
  end
  
  def destroy
    respond_with(Group.find(params[:id]).destroy)
  end
end
