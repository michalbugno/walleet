class Api::V1::GroupsController < ApplicationController
  respond_to :json

  def index
    respond_with Group.all
  end

  def create
    respond_with(Group.create(params[:group]), :location => "")
  end

  def add_person
    group = Group.find(params[:id])
    # if exist add, if no -> create, invite and add to group
    # GroupMembershipManager.invite_user(group, params[:person_email])
    
    person = Person.find(params[:person_id])
    respond_with(GroupMembershipManager.new(group, person).connect, :location => "")
  end

  def remove_person
    group = Group.find(params[:id])
    person = Person.find(params[:person_id])
    respond_with(GroupMembershipManager.new(group, person).disconnect)
  end

  def destroy
    respond_with(Group.find(params[:id]).destroy)
  end
end
