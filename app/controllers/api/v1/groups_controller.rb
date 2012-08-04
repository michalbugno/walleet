require 'responders/group_responder'
require 'group_membership_manager'
require 'responders/feed_responder'
require 'group_feed_fetcher'

class Api::V1::GroupsController < Api::BaseController
  respond_to :json
  before_filter :find_group, :only => [:show, :feed, :add_person, :remove_person, :destroy]

  def index
    respond_with current_person.groups
  end

  def show
    respond_with(@group, :responder => GroupResponder)
  end

  def create
    group = Group.create(params[:group])
    GroupMembershipManager.new(group, current_person).connect
    respond_with(group, :location => "")
  end

  def feed
    time = Time.parse(params[:time])
    feed = GroupFeedFetcher.new(10, time, @group)
    respond_with(feed, :responder => FeedResponder)
  end

  def destroy
    undo = Undoable.group_deletion(@group, current_person)
    respond_with(undo, :location => "") do |format|
      format.json { render :text => undo.to_json }
    end
  end

  private
  def find_group
    begin
      @group = current_person.groups.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return render :nothing => true, :status => 404
    end
  end
end
