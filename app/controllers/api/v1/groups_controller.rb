require 'responders/group_responder'
require 'group_membership_manager'

class Api::V1::GroupsController < Api::BaseController
  respond_to :json

  def index
    respond_with Group.all
  end

  def show
    group = Group.find(params[:id])
    respond_with group, :responder => GroupResponder
  end

  def create
    group = Group.create(params[:group])
    GroupMembershipManager.new(group, current_person).connect
    respond_with(group, :location => "")
  end

  def add_person
    group = Group.find(params[:id])
    person = Person.find(params[:person_id])
    GroupMembershipManager.new(group, person).connect
    respond_with("", :location => "")
  end

  def remove_person
    group = Group.find(params[:id])
    person = Person.find(params[:person_id])
    GroupMembershipManager.new(group, person).disconnect
    respond_with("", :location => "")
  end

  def destroy
    respond_with(Group.find(params[:id]).destroy)
  end
end
