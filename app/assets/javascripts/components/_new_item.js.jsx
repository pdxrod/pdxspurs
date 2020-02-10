const NewFruit = (props) => {
  let formFields = {}

  return(
    <form onSubmit={ (e) => { props.handleFormSubmit(formFields.classification.value, formFields.name.value, formFields.description.value); e.target.reset();} }>
      <input ref={input => formFields.classification = input} placeholder='type, e.g. "car"'/>
      <input ref={input => formFields.name = input} placeholder='name'/>
      <input ref={input => formFields.description = input} placeholder='description' />
      <button>Submit</button>
    </form>
  )
}
