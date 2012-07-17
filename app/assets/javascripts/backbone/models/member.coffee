class Models.Member extends Backbone.Model
  url: ->
    "/api/v1/groups/" + this.get("group").get("id") + ".json"

  sync: (method, model, options) =>
    if (method == "create")
      options.url = "/api/v1/groups/" + this.get("group").get("id") + "/add_person.json"
    Backbone.sync(method, model, options)

  toJSON: =>
    console.log(this)
    r = {
      id: this.get("group").get("id")
    }
    if this.get("person_id")
      r.person_id = this.get("person_id")
    else
      r.name = this.get("name")
    r
