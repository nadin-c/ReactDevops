import React, { Component } from "react";
import "./App.css";
import TodoElement from "./Components/TodoElement";

class App extends Component {
  constructor() {
    super();
    // Create a reference to the input element
    this.taskInput = React.createRef();
    // Initialize state with one default TodoElement
    this.state = { TODOs: [<TodoElement key={1} taskText="Do the chores." />] };
  }

  // Function to add a new todo task
  add = () => {
    // Check if the input field has a value
    if (this.taskInput.current.value) {
      // Get the value from the input field
      const taskText = this.taskInput.current.value;

      // Update state by adding a new TodoElement to the TODOs array
      this.setState((prevState) => ({
        TODOs: [
          ...prevState.TODOs,
          // Create a new TodoElement with a unique key and the task text
          <TodoElement key={prevState.TODOs.length + 1} taskText={taskText} />,
        ],
      }));

      // Clear the input field after adding a task
      this.taskInput.current.value = "";
    }
  };

  render() {
    return (
      <div className="TodoContainer">
        <div className="TodoCreatorContainer">
          {/* Input field for adding new tasks */}
          <input type="text" ref={this.taskInput} />
          {/* Button to trigger the add function */}
          <button onClick={this.add}>ADD</button>
        </div>
        {/* Container to display the list of todo tasks */}
        <div className="TodoElementContainer">{this.state.TODOs}</div>
      </div>
    );
  }
}

export default App;
