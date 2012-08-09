class Views.ResetPassword extends Backbone.View
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
        person.bind("change", window.Auth.login)
        person.fetch({async: false})
        Backbone.history.navigate('/', true)
      error: -> console.log "error"
      data:
        person:
          reset_password_token: @options.token
          password: this.$('[name="password"]').val()
    }


