class Models.Feed extends Backbone.Model

class Collections.Feed extends Backbone.Collection
  model: Models.Feed

  initialize: (arr, options) =>
    @group = options.group
    @time = moment().utc().add('seconds', 2).format()

  parse: (object) =>
    @time = object.next_timestamp
    super(object.items)

  url: =>
    if @group
      "/api/v1/groups/" + @group.get("id") + "/feed.json"
    else
      "/api/v1/me/feed.json"

  resetFeed: =>
    this.reset([], {silent: true})
    @time = moment().utc().add('seconds', 2).format()
    this.fetchNextPage()

  lastPage: =>
    @time == null

  fetchNextPage: =>
    return if this.lastPage()

    this.fetch(
      data: {time: @time}
      add: true
      success: =>
        this.trigger("reset")
    )
