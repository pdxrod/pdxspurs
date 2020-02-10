class Fruit extends React.Component{

  constructor(props){
    super(props);
    this.state = {
      editable: false
    }
    this.handleEdit = this.handleEdit.bind(this)
  }

  handleEdit(){
   if(this.state.editable){
      let name = this.name.value
      let classification = this.classification.value
      let category = this.props.fruit.category
      let description = this.description.value
      let id = this.props.fruit.id
      let fruit = {id: id, classification: classification, name: name, description: description}
      this.props.handleUpdate(fruit)
    }
    this.setState({
      editable: ! this.state.editable
    })
  }

  render(){
    let name = this.state.editable ? <input type='text' ref={input => this.name = input} defaultValue={this.props.fruit.name}/>:<b>{this.props.fruit.name}</b>
    let description = this.state.editable ? <input type='text' ref={input => this.description = input} defaultValue={this.props.fruit.description}/>:<p>{this.props.fruit.description}</p>
    let classification = this.state.editable ? <input type='text' ref={input => this.classification = input} defaultValue={this.props.fruit.classification}/>:<span></span>
    let category = <h3>{this.props.fruit.category}</h3>
    return(
      <div>
        {category}
        <ul>
          {classification}
          {name}
          {description}
          <button onClick={() => this.handleEdit()}>{this.state.editable? 'Submit' : 'Edit'}</button>
          <button onClick={() => this.props.handleDelete(this.props.fruit.id)}>Delete</button>
        </ul>
      </div>
    )
  }
}
