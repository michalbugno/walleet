class Views.FeedView extends BasicView
  template: JST['backbone/templates/feed']

  events:
    "click #load-feed": "loadNextPage"

  initialize: (options) =>
    options ||= {}
    @group = options.group
    @feed = new Collections.Feed([], {group: @group})
    @feed.bind("reset", this.render)
    @feed.fetchNextPage()

  render: =>
    this.$el.html(this.template(this.templateContext()))

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
      date = moment(el.date)
      el.date = date.fromNow()
      el.fullDate = date.calendar()
      switch el.feed_type
        when "new_debt"
          formattedCurrency = Helpers.formatAmount(el.amount, el.currency)
          if el.text
            el.text = formattedCurrency + " (" + el.text + ")"
          else
            el.text = formattedCurrency
        when "new_member"
          el.text = "New member #{el.name} joined"
    )
    feed: feed
    lastPage: @feed.lastPage()
