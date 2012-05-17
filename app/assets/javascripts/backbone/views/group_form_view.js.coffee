class Walleet.Views.GroupFormView extends Backbone.View
  template: JST["backbone/templates/group_form"]

  initialize: (options) ->
    super(options)

    @collection = options.collection

    this.render()

  render: ->
    $(@el).html @template()
    @groupName = @$('#group-name')

    @$('form').on 'submit', (event) =>
      event.preventDefault()

      @collection.create { name: @groupName.val() }
      @collection.fetch()

      @groupName.val('')

