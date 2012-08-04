class Models.Membership extends Backbone.Model
  url: ->
    if this.isNew()
      "/api/v1/memberships.json"
    else
      "/api/v1/memberships/" + this.get("id") + ".json"
