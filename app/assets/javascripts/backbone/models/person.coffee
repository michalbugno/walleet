class Models.Person extends Backbone.Model
  url: "/api/v1/person.json"

  sync: (method, model, opts) =>
    if (method == "delete")
      opts.url = "/api/v1/person/sign_out.json"
    else if (method == "create")
      if model.get("signup")
        opts.url = "/api/v1/person.json"
      else
        opts.url = "/api/v1/person/sign_in.json"
    Backbone.sync(method, model, opts)

  defaults:
    email: ""
    password: ""

  toJSON: =>
    attrs = this.attributes
    delete attrs.signup
    person: attrs
