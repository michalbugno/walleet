class Views.Login extends Backbone.View
  template: JST['backbone/templates/login']

  el: "#content"

  events:
    'submit form': 'signIn'

  render: =>
    this.$el.html(this.template())
    @email = this.$('#person-email')
    @password = this.$('#person-password')

    @email.focus()

  signIn: (event) =>
    event.preventDefault()

    member = new Models.Person({email: @email.val(), password: @password.val()})
    member.save({}, {
      async: false,
      success: (model, response) =>
        Auth.login(model)
        App.navigate("/")
      error: (model, response) =>
        alert = new Views.AlertView(el: this.alertContainer())
        alert.addError("Incorrect email and/or password", {noHide: true})
        alert.render()
        @email.focus()
        @email.select()
    })

  alertContainer: =>
    container = $(".alert-container", this.$el)
    if container.length == 0
      container = $(".alert-container")
    container
