class Models.Group extends Backbone.Model
  url: ->
    "/api/v1/groups/" + this.get("id") + ".json"


class Collections.GroupCollection extends Backbone.Collection
  model: Models.Group
  url: "/api/v1/groups"

  comparator: (group) -> group.get('name')
