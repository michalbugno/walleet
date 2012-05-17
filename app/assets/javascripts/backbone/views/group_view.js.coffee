class Walleet.Views.GroupView extends Backbone.View
  sidebarTemplate: JST['backbone/templates/group_sidebar']

  initialize: (options) ->
    super(options)

    @currentGroup = options.group

    this.render()

  render: ->
    if @currentGroup
      $('#group-sidebar').html @sidebarTemplate(group: @currentGroup)
    else
      $('#group-sidebar').html('')

  showGroup: (group) ->
    @currentGroup = group
    this.render()
