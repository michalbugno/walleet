class Views.GroupFormView extends BasicView
  template: JST["backbone/templates/group_form"]

  events:
    "submit form": "createGroup"
    "input #group-name": "updateAddGroupButton"    

  initialize: (options) ->
    @collection = App.groups
    this.render()

  render: =>
    this.$el.html(this.template())
    @groupName = this.$('#group-name')
    @addGroupButton = this.$("#add-group-button")
    this.updateAddGroupButton()    

  createGroup: (event) =>
    event.preventDefault()
    group = new Models.Group({name: @groupName.val()})
    group.save({}, {
      success: =>
        @groupName.val("")
        App.groups.setCurrentId(group.get("id"))
        App.groups.fetch()
        App.nav.navigate("group:show", group.get("id"))
      error: =>
        alert = new Views.AlertView(el: this.alertContainer())
        @groupName.focus()        
        alert.addError("Name can't be empty", {noHide: false})
        alert.render()        
    })
    
  updateAddGroupButton: =>
    if @groupName.val()
      @addGroupButton.removeAttr("disabled")
    else
      @addGroupButton.attr("disabled", true);
     
     
  alertContainer: =>
    container = $(".alert-container", this.$el)
    if container.length == 0
      container = $(".alert-container")
    container    
