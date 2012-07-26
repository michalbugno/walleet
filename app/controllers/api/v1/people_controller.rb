require 'person_feed_fetcher'
require 'responders/feed_responder'

class Api::V1::PeopleController < Api::BaseController
  respond_to :json

  def show
    respond_with(current_person)
  end

  def related
    respond_with(current_person.related)
  end

  def feed
    feed = PersonFeedFetcher.new(10, params[:time], current_person)
    response = {
      :items => feed.items,
      :next_timestamp => feed.next_timestamp,
    }
    respond_with(feed, :responder => FeedResponder)
  end
end
