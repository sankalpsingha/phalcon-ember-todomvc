<?php

/**
 * Created by PhpStorm.
 * User: sankalpsingha
 * Date: 3/11/14
 * Time: 8:48 PM
 */
class TodoController extends ControllerBase
{

    public function getAll()
    {
        $todos = Todo::find();
        $array = [];
        if(count($todos)){
            foreach ($todos as $key){
                $array[] = array(
                    'id' => $key->id,
                    'title' => $key->title,
                    'isCompleted' => $key->isCompleted,
                );
            }
            echo json_encode(array('todos'=>$array));
        }else{
            echo json_encode(array('todos'=> array()));
        }
    }


    public function editTodo($id)
    {
        $todo = Todo::findFirst($id);
        $data = json_decode($this->request->getRawBody());
        $todo->title = $data->todo->title;
        $todo->isCompleted = (int)$data->todo->isCompleted;
        $todo->update();
    }

    public function deleteTodo($id){
        $todo = Todo::findFirst($id);
        $todo->delete();
    }


    public function addTodo()
    {
        $data = json_decode($this->request->getRawBody());
        $todo = new Todo();

        $todo->title = $data->todo->title;
        $todo->isCompleted = 0;

        if($todo->save()){
            json_encode(array(
                'id' => $todo->id,
                'title' => $todo->title,
                'isCompleted' => false,
            ));
        }

    }

} 