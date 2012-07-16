class Routers.Walleet extends Backbone.Router
  routes: {
    "": "mainPage"
    "group/:id": "groupShow"
    "sign_in": "signIn"
  }

  mainPage: ->
    this.clear()
    console.log("mainpage")

  groupIndex: ->
    this.clear()
    new Layouts.GroupIndex().render()
    @groups = new Collections.GroupCollection()

    new Views.GroupBarView(el: $("#group-bar"), collection: @groups)
    new Views.GroupFormView(el: $("#group-form"), collection: @groups)
    @groups.fetch()


  groupShow: (groupId) =>
    this.clear()
    new Layouts.GroupIndex().render()
    @groups = new Collections.GroupCollection()
    @group = new Models.Group({id: groupId})
    new Views.GroupView(el: $("#main-content"), group: @group)
    new Views.GroupBarView(el: $("#group-bar"), collection: @groups, currentId: groupId)
    new Views.AddMemberView(el: $("#side-content"), group: @group).render()
    @group.fetch()
    @groups.fetch()

  signIn: =>
    this.clear()
    new Layouts.PersonLogin().render()

  clear: =>
    $("#body").html("")
