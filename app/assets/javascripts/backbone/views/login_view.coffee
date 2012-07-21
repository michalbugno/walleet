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
        Router.navigate("", {trigger: true})
      error: (response) => console.log("no auth")
    })
