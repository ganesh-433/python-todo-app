from fastapi import FastAPI, HTTPException
from app.models import Task

app = FastAPI()

tasks = []  # In-memory store

@app.get("/")
def read_root():
    return {"message": "Welcome to the To-Do API"}

@app.get("/tasks")
def get_tasks():
    return tasks

@app.post("/tasks")
def create_task(task: Task):
    tasks.append(task)
    return task

@app.put("/tasks/{task_id}")
def update_task(task_id: int, updated_task: Task):
    for idx, task in enumerate(tasks):
        if task.id == task_id:
            tasks[idx] = updated_task
            return updated_task
    raise HTTPException(status_code=404, detail="Task not found")

@app.delete("/tasks/{task_id}")
def delete_task(task_id: int):
    for task in tasks:
        if task.id == task_id:
            tasks.remove(task)
            return {"message": "Task deleted"}
    raise HTTPException(status_code=404, detail="Task not found")