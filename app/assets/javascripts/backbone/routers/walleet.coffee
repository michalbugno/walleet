class Walleet.Routers.Walleet extends Backbone.Router
  routes: {
    "": "groupIndex"
    "group/:id": "groupShow"
    "sign_in": "signIn"
  }

  groupIndex: ->
    this.clear()
    new window.Walleet.Layouts.GroupIndex().render()
    @groups = new window.Walleet.Collections.GroupCollection()

    new window.Walleet.Views.GroupBarView(el: $("#group-bar"), collection: @groups)
    new window.Walleet.Views.GroupFormView(el: $("#group-form"), collection: @groups)
    @groups.fetch()


  groupShow: (groupId) =>
    this.clear()
    new window.Walleet.Layouts.GroupIndex().render()
    @groups = new window.Walleet.Collections.GroupCollection()
    @group = new window.Walleet.Models.Group({id: groupId})
    new window.Walleet.Views.GroupView(el: $("#main-content"), group: @group)
    new window.Walleet.Views.GroupBarView(el: $("#group-bar"), collection: @groups, currentId: groupId)
    new window.Walleet.Views.AddMemberView(el: $("#side-content"), group: @group).render()
    @group.fetch()
    @groups.fetch()

  signIn: =>
    this.clear()
    new window.Walleet.Layouts.PersonLogin().render()

  clear: =>
    $("#body").html("")
