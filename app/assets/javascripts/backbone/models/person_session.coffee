class Walleet.Models.PersonSession extends Backbone.Model
  url: "/people/sign_in.json"

  defaults:
    email: ""
    password: ""

  toJSON: =>
    person: this.attributes
