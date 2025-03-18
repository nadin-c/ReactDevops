import React, { Component } from "react";

class TodoElement extends Component {
  constructor(props) {
    super(props);
    // Initialize state with default values
    this.state = {
      isRendered: true, // Flag to determine if the element should be rendered
      isChecked: false, // Flag to determine if the task is checked
      taskText: this.props.taskText, // Task text passed as props
    };
  }

  // Function to mark the task as checked
  check = () => {
    this.setState({
      isChecked: true,
    });
  };

  // Function to mark the task as unchecked
  unCheck = () => {
    this.setState({
      isChecked: false,
    });
  };

  // Function to delete the todo element
  deleteElement = () => {
    this.setState({ isRendered: false });
  };

  // Function to handle text input for editing the task
  setText = (event) => {
    if (event.keyCode === 13) { // If Enter key is pressed
      this.setState({ taskText: event.target.value });
    } else if (event.keyCode === 27) { // If Escape key is pressed
      this.setState({ taskText: this.state.prevTaskText, isChecked: false });
    }
  };

  // Function to switch to edit mode for the task text
  editText = () => {
    this.setState({
      prevTaskText: this.state.taskText, // Store the previous task text
      taskText: (
        <input className="TaskInput" type="text" onKeyDown={this.setText} />
      ), // Render an input field for editing
    });
  };

  render() {
    // Determine the class for the task text based on whether it's checked or not
    const taskTextClass = this.state.isChecked
      ? "TaskText strikethrough"
      : "TaskText";

    // Render the todo element if it's set to be rendered
    if (this.state.isRendered) {
      return (
        <>
          <div className="TodoElement">
            {/* Checkbox to mark the task as checked */}
            <input
              type="checkbox"
              checked={this.state.isChecked}
              className="TaskCheck"
              onChange={() =>
                this.state.isChecked ? this.unCheck() : this.check()
              }
            />
            <div className="taskControls">
              {/* Task text */}
              <p className={taskTextClass}>{this.state.taskText}</p>
              {/* Button to edit the task text */}
              <button className="transparent" onClick={this.editText}>
                <img src="./src/assets/edit.svg" alt="Edit" />
              </button>
              {/* Button to delete the todo element */}
              <button className="transparent" onClick={this.deleteElement}>
                <img src="./src/assets/delete.svg" alt="Delete" />
              </button>
            </div>
          </div>
        </>
      );
    } else {
      return <></>; // If the element is not rendered, return an empty fragment
    }
  }
}

export default TodoElement;
