class Views.FeedView extends Backbone.View
  template: JST['backbone/templates/feed']

  events:
    "click #load-feed": "loadNextPage"

  initialize: (options) =>
    this.el = options.el
    @group = options.group
    @feed = new Collections.Feed([], {group: @group})
    if @group
      @group.bind("change", this.resetFeed)
    else
      @feed.fetchNextPage()
    @feed.bind("reset", this.render)

  render: =>
    $(this.el).html(this.template(this.templateContext()))
    $("#load-feed").click((event) =>
      this.loadNextPage(event)
    )

  resetFeed: =>
    @feed.resetFeed()

  loadFeed: =>
    @feed.fetchNextPage()

  loadNextPage: (event) =>
    event.preventDefault()
    this.loadFeed()

  templateContext: =>
    feed = @feed.toJSON()
    _.each(feed, (el) =>
      el.date = moment(el.date).calendar()
      switch el.feed_type
        when "new_debt"
          el.text = "+" + el.amount
        when "new_member"
          el.text = el.name + " joined"
    )
    feed: feed
    lastPage: @feed.lastPage()
