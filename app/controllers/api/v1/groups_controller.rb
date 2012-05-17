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
    person = Person.find(params[:person_id])
    respond_with(GroupMembershipInvite.new(group, person).add_person_to_group, :location => "")
  end

  def remove_person
    group = Group.find(params[:id])
    person = Person.find(params[:person_id])    
    respond_with(GroupMembershipRemove.new(group, person).remove_person_from_group)
  end
  
  def destroy
    respond_with(Group.find(params[:id]).destroy)
  end
end
