# Based on the todo example on the Deployd website, written in CoffeeScript

mod = angular.module 'ngBoilerplate.dpdExample', [
  'ui.router'
  'placeholders'
  'ui.bootstrap'
]

mod.config ($stateProvider) ->
  $stateProvider.state 'todo',
    url: '/todo'
    views:
      main:
        controller: 'TodoDpdCtrl'
        templateUrl: 'dpd-example/dpd-example.tpl.html'
    data:
      pageTitle: 'Deployd Example App'

mod.controller 'TodoDpdCtrl', ($scope, $http) ->
  $scope.todos = []
  dpd.todos.get (todos, err) ->
    if err
      return console.log err
    
    $scope.todos = todos
    $scope.$apply()

  $scope.addTodo = (title) ->
    dpd.todos.post title: title, (todo, err) ->
      if err?
        return console.log err

      $scope.newTodoTitle = ''
      $scope.todos.push todo
      $scope.$apply()

  $scope.changeCompleted = (todo) ->
    dpd.todos.put todo.id, completed:todo.completed, (result, err) ->
      if err
        return console.log err

  $scope.removeCompletedItems = ->
    dpd.todos.get completed:true, (todos) ->
      todos.forEach (t) ->
        deleteTodo t
        $scope.$apply()

  deleteTodo = (todo) ->
    # NOTE: params for delete statement ensure the task wasnt marked as
    # uncomplete since the time we got the task and the time we delete it
    dpd.todos.del id:todo.id, completed:true, (err) ->
      return console.log err if err
      todosMatched = $scope.todos.filter (t) -> t.id is todo.id
      index = $scope.todos.indexOf todosMatched[0]
      unless index is -1
        $scope.todos.splice index, 1
      $scope.$apply()

