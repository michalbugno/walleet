class Models.Person extends Backbone.Model
  url: "/api/v1/me.json"

  sync: (method, model, opts) =>
    if (method == "delete")
      opts.url = "/people/sign_out"
    else if (method == "create")
      if model.get("signup")
        opts.url = "/people.json"
      else
        opts.url = "/people/sign_in.json"
    Backbone.sync(method, model, opts)

  defaults:
    email: ""
    password: ""

  toJSON: =>
    attrs = this.attributes
    delete attrs.signup
    person: attrs
