class window.Auth
  constructor: ->
    _.extend(this, Backbone.Events)

  loggedIn: =>
    !!@person

  login: (person) =>
    @person = person
    this.trigger("login")

  logout: =>
    App.groups = new Collections.GroupCollection
    if @person
      @person.destroy()
      @person = null
      this.trigger("logout")
