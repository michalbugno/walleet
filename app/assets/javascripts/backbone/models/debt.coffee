class Walleet.Models.Debt extends Backbone.Model
  url: ->
    if this.isNew()
      "/api/v1/debts.json"
    else
      "/api/v1/debts/" + this.get("id") + ".json"
