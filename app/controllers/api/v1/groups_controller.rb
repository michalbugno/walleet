require 'responders/group_responder'
require 'group_membership_manager'
require 'responders/feed_responder'
require 'group_feed_fetcher'

class Api::V1::GroupsController < Api::BaseController
  respond_to :json
  before_filter :find_group, :only => [:show, :feed, :destroy, :update]

  def index
    respond_with current_person.groups
  end

  def show
    respond_with(@group, :responder => GroupResponder)
  end

  def create
    group = Group.new(params[:group])
    currency = Currency.smart_build(current_person)
    ActiveRecord::Base.transaction do
      currency.save!
      group.currency = currency
      group.save!
    end
    GroupMembershipManager.new(group, current_person).connect
    respond_with(group, :location => "")
  end

  def update
    group_params = params[:group]
    currency_params = params[:currency]
    currency_params.select! { |name| ["decimal_precision", "symbol", "decimal_separator", "thousands_separator"].include?(name) }
    currency = Currency.for_group(@group)
    currency.update_attributes!(currency_params)
    @group.update_attributes!(params[:group])
    respond_with(@group, :location => "")
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
