class Routers.Walleet extends Backbone.Router
  routes: {
    "": "mainPage"
    "welcome": "welcome"
    "group/:id": "groupShow"
    "groups": "groupIndex"
    "person/sign_in": "signIn"
  }

  welcome: =>
    new Layouts.Main().render()
    new Views.Welcome().render()

  mainPage: =>
    this.clear()
    if !Auth.loggedIn()
      Router.navigate("#welcome", {trigger: true})
    else
      new Layouts.Main().render()

  groupIndex: =>
    this.clear()
    new Layouts.Main().render()
    @groups = new Collections.GroupCollection()

    new Views.Groups(el: $("#content")).render()
    new Views.GroupBarView(el: $("#group-bar"), collection: @groups)
    new Views.GroupFormView(el: $("#group-form"), collection: @groups)
    @groups.fetch()

  groupShow: (groupId) =>
    this.clear()
    new Layouts.Main().render()
    @groups = new Collections.GroupCollection()
    @group = new Models.Group({id: groupId})
    new Views.GroupView(el: $("#main-content"), group: @group)
    new Views.GroupBarView(el: $("#group-bar"), collection: @groups, currentId: groupId)
    new Views.AddMemberView(el: $("#side-content"), group: @group).render()
    @group.fetch()
    @groups.fetch()

  signIn: =>
    this.clear()
    new Layouts.Main().render()
    new Views.Login().render()

  clear: =>
    $("#body").html("")
