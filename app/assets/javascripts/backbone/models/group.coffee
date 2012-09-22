class Models.Group extends Backbone.Model
  url: ->
    if this.isNew()
      "/api/v1/groups.json"
    else
      "/api/v1/groups/" + this.get("id") + ".json"

  parse: (object) =>
    super(object.group)

  formatValue: (value) =>
    Helpers.formatAmount(value, this.get("currency"))

  toJSON: =>
    {
      group: super()
    }

class Collections.GroupCollection extends Backbone.Collection
  model: Models.Group

  parse: (object) =>
    super(object.items)

  url: "/api/v1/groups.json"

  setCurrentId: (id) =>
    @currentId = id
    this.trigger("reset")
