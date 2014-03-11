<?php

$loader = new \Phalcon\Loader();

// This is for the registration of the files.
$loader->registerDirs(
    array(
        '../../app/controllers/',
        '../../app/models/'
    )
)->register();

$app = new \Phalcon\Mvc\Micro();

$app->setService('db',function(){
    return new \Phalcon\Db\Adapter\Pdo\Mysql(
        array(
            'host' => 'localhost',
            'username' => 'root',
            'password' => 'root',
            'dbname' => 'phalcon'
        )
    );
});



// All the routes will be here after this....


$todosController = new \Phalcon\Mvc\Micro\Collection();
$todosController->setHandler(new TodoController());

$todosController->get('/api/todos','getAll');
$todosController->post('/api/todos','addTodo');

$todosController->put('/api/todos/{id}','editTodo');
$todosController->delete('/api/todos/{id}','deleteTodo');
$app->mount($todosController);


//

$app->handle();