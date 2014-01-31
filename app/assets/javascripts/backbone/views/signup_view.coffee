class Views.Signup extends BasicView
  template: JST['backbone/templates/signup']
  events:
    "submit .signup-form": "signup"

  render: =>
    this.$el.html(this.template())
    @email = this.$(".person-email")
    @password = this.$(".person-password")
    @email.focus()

  signup: (event) =>
    event.preventDefault()
    person = new Models.Person({
      email: @email.val()
      password: @password.val()
      signup: true
    })
    person.save({}, {
      success: (model) =>
        App.auth.login(model)
        App.nav.navigate("root:welcome")
      error: (model, json) =>
        alert = new Views.AlertView(el: this.$(".errors"))
        errors = []
        response = JSON.parse(json.responseText)
        _.each(response.errors, (values, key) =>
          _.each(values, (error) =>
            errors.push(error)))
        alert.addError(errors, noHide: true)
        alert.render()
    })
