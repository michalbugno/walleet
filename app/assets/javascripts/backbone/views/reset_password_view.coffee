class Views.ResetPassword extends BasicView
  template: JST['backbone/templates/reset_password']

  events:
    'submit #reset-password-form': 'submit'

  render: ->
    this.$el.html(this.template())

  submit: (event) ->
    event.preventDefault()
    $.ajax '/people/password.json', {
      type: 'put'
      success: ->
        person = new Models.Person
        person.bind("change", App.auth.login)
        person.fetch({async: false})
        App.nav.navigate("root")
      error: -> console.log "error"
      data:
        person:
          reset_password_token: @options.token
          password: this.$('[name="password"]').val()
    }


