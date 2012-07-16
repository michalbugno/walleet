class Layouts.PersonLogin extends Backbone.View
  template: JST['backbone/templates/layouts/person_login']

  el: "#body"

  events:
    'submit form': 'signIn'

  render: =>
    this.$el.html(this.template())

  signIn: (event) =>
    @email = this.$('#person-email')
    @password = this.$('#person-password')
    event.preventDefault()

    member = new Models.PersonSession({email: @email.val(), password: @password.val()})
    member.save({}, {
      success: (response) =>
        console.log(response)
      error: (response) =>
        console.log(response)
      })
