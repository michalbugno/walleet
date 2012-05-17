$ ->
  Message = Backbone.Model.extend {}

  MessageStore = Backbone.Collection.extend(
    model: Message
    url: 'http://localhost:4567/messages'
  )

  messages = new MessageStore
