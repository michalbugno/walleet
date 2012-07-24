class Models.Undo extends Backbone.Model
  url: ->
    if this.isNew()
      "/api/v1/undos.json"
    else
      "/api/v1/undos/" + this.get("id") + ".json"
