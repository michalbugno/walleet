class Views.Login extends BasicView
  template: JST['backbone/templates/login']

  events:
    'submit form': 'signIn'

  render: =>
    this.$el.html(this.template())
    @email = this.$('.person-email')
    @password = this.$('.person-password')

    @email.focus()

  signIn: (event) =>
    event.preventDefault()

    member = new Models.Person({email: @email.val(), password: @password.val()})
    member.save({}, {
      success: (model, response) =>
        App.auth.login(model)
        App.nav.navigate("groups")
      error: (model, response) =>
        alert = new Views.AlertView(el: this.$(".errors"))
        alert.addError("Incorrect email and/or password", {noHide: true})
        alert.render()
        @email.focus()
        @email.select()
    })
