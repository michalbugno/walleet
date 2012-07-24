class Routers.Walleet extends Backbone.Router
  routes: {
    "": "mainPage"
    "welcome": "welcome"
    "goodbye": "goodbye"
    "groups/:id": "groupShow"
    "person/sign_in": "signIn"
    "*anything": "notFound"
  }

  welcome: =>
    this.clear()
    new Layouts.Main().render()
    new Views.Welcome().render()

  goodbye: =>
    this.clear()
    new Layouts.Main().render()
    new Views.Goodbye().render()

  mainPage: =>
    this.clear()
    if !Auth.loggedIn()
      Router.navigate("welcome", {trigger: true})
    else
      new Layouts.Main().render()
      new Views.GroupListView(el: "#group-list")
      new Views.GroupFormView(el: "#group-form-view-container")

  groupShow: (groupId) =>
    this.clear()
    new Layouts.Main().render()

    @group = new Models.Group({id: groupId})

    new Views.GroupListView(el: "#group-list")
    new Views.GroupView({group: @group, el: "#content"})

    @group.fetch()

  signIn: =>
    this.clear()
    new Layouts.Main().render()
    new Views.Login().render()

  notFound: (path) =>
    this.clear()
    new Layouts.Main().render()
    new Views.NotFoundView(el: "#content", path: path).render()

  clear: =>
    $("#body").html("")
