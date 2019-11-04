export class App {

  constructor() {
    this.heading = 'Tâches';
    this.todos = [];
    this.todoDescription = '';
    this.descriptionHasFocus = true;
    this.categories = ['Personnel', 'Professionnel'];
    this.selectedCategory = '';
    this.categoriesToDisplay = ['Personnel', 'Professionnel', 'Tout'];
    this.displayedCategory = 'Tout';
  }

  addTodo() {
    if (this.todoDescription) {
      this.todos.push({
        description: this.todoDescription,
        done: false,
        category: this.selectedCategory
      });
      this.todoDescription = '';
      this.descriptionHasFocus = true;
    }
  }

  removeTodo(todo) {
    let index = this.todos.indexOf(todo);
    if (index !== -1) {
      this.todos.splice(index, 1);
    }
  }
}
