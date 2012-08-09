class Views.Signup extends Backbone.View
  template: JST['backbone/templates/signup']
  events:
    "submit #signup-form": "signup"

  render: =>
    this.$el.html(this.template())
    @email = this.$("#person-email")
    @password = this.$("#person-password")
    @email.focus()

  signup: (event) =>
    event.preventDefault()
    person = new Models.Person({
      email: @email.val()
      password: @password.val()
      signup: true
    })
    person.save({}, {
      success: =>
        Router.navigate("/person/sign_in", {trigger: true})
        alert = new Views.AlertView(el: this.alertContainer())
        alert.addNotice("You can sign in now!")
        alert.render()
      error: (model, json) =>
        alert = new Views.AlertView(el: this.alertContainer())
        alert.addError("Something went wrong")
        alert.render()
    })

  alertContainer: =>
    container = $(".alert-container", this.$el)
    if container.length == 0
      container = $(".alert-container")
    container
