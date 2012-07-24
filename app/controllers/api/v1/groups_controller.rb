require 'responders/group_responder'
require 'group_membership_manager'

class Api::V1::GroupsController < Api::BaseController
  respond_to :json

  def index
    respond_with current_person.groups
  end

  def show
    group = Group.visible.find(params[:id])
    respond_with group, :responder => GroupResponder
  end

  def create
    group = Group.create(params[:group])
    GroupMembershipManager.new(group, current_person).connect
    respond_with(group, :location => "")
  end

  def add_person
    group = Group.visible.find(params[:id])
    if params[:person_id]
      person = Person.find(params[:person_id])
    else
      person = params[:name]
    end
    GroupMembershipManager.new(group, person).connect
    respond_with("", :location => "")
  end

  def remove_person
    group = Group.visible.find(params[:id])
    person = Person.find(params[:person_id])
    GroupMembershipManager.new(group, person).disconnect
    respond_with("", :location => "")
  end

  def destroy
    group = Group.visible.find(params[:id])
    undo = Undoable.group_deletion(group, current_person)
    respond_with(undo, :location => "") do |format|
      format.json { render :text => undo.to_json }
    end
  end
end
