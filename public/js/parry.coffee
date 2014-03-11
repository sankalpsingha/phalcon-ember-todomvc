App = Ember.Application.create
  LOG_TRANSITION : true

App.ApplicationAdapter = DS.RESTAdapter.extend
  namespace : 'api'



# Let's create the router
App.Router.map ->
  @resource 'todos', path : '/', ->
    @route 'active'
    @route 'completed'

###
App.Router.reopen
  location : 'history'
###

# Creating the model.
App.Todo = DS.Model.extend
  title : DS.attr('string')
  isCompleted : DS.attr('boolean')


App.TodosRoute = Ember.Route.extend
  model : ->
    @store.find 'todo'


App.TodosIndexRoute = Ember.Route.extend
  model : ->
    @modelFor('todos')


App.TodosController = Ember.ArrayController.extend
  sortProperties : ['title']
  actions :
    createTodo : ->
      title = @get 'newTitle'
      title = title.trim()

      model = @store.createRecord('todo',
        title : title
        isCompleted : false
      )
      model.save()

      #Clear the field.
      @set 'newTitle',''

    clearCompleted : ->
      model = @filterBy 'isCompleted',true
      model.invoke 'deleteRecord'
      model.invoke 'save'

  completed : (->
    @filterBy('isCompleted',true).get 'length'

  ).property('@each.isCompleted')
  remaining : (->
    @filterBy('isCompleted',false).get 'length'
  ).property('@each.isCompleted')

  inflection : (->
    remaining = @get 'remaining'
    if remaining > 1
      "todos"
    else
      "todo"
  ).property('remaining')


App.TodoController = Ember.ObjectController.extend

  isEditing : false
  isCompleted : ((key,value) ->
    model = @get 'model'
    if value is undefined
      model.get 'isCompleted'
    else
      model.set 'isCompleted',value
      model.save()
      value
    ).property('@each.isCompleted')

  actions :
    deleteTodo : ->
      model = @get 'model'
      model.deleteRecord()
      model.save()

    editTodo : ->
      @set('isEditing',true)

    acceptChanges : ->
      @set 'isEditing',false
      model = @get 'model'
      title = @get 'title'
      model.set 'title',title
      model.save()


App.TodosActiveRoute = Ember.Route.extend
  model : ->
    @store.filter 'todo',(todo)->
      !todo.get('isCompleted')

  renderTemplate : (controller)->
    @render 'todos/index', controller : controller


App.TodosCompletedRoute = Ember.Route.extend
  model : ->
    @store.filter 'todo',(todo)->
      todo.get('isCompleted')

  renderTemplate : (controller)->
    @render 'todos/index', controller : controller



App.EditTodoView = Ember.TextField.extend
  didInsertElement : ->
    @$().focus()

Ember.Handlebars.helper 'edit-todo',App.EditTodoView




