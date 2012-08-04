require 'group_membership_manager'

class Api::V1::MembershipsController < Api::BaseController
  respond_to :json
  before_filter :find_membership, :only => [:destroy]

  def create
    if params[:person_id]
      person = Person.find(params[:person_id])
    else
      person = params[:name]
    end
    group = current_person.groups.find(params[:id])
    GroupMembershipManager.new(group, person).connect
    respond_with("", :location => "")
  end

  def destroy
    GroupMembershipManager.from_membership(@membership).disconnect
    respond_with("", :location => "")
  end

  private
  def find_membership
    begin
      @membership = current_person.related_memberships.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return render :nothing => true, :status => 404
    end
  end
end
