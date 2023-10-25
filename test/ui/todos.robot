*** Settings ***
Resource        setup_teardown.resource
Suite Setup     Prepare the test suite
Test Setup      Prepare the test case
Test Teardown   Clean up the test case
Suite Teardown  Clean up the test suite

*** Variables ***
&{CATEGORIES}
...             private=Personnel
...             professional=Professionnel
...             all=Tout

*** Test Cases ***
Should do nothing
  No operation

I can add a todo
  Submit a todo  Adopter de bonnes pratiques de test
  A new todo should be created  1  Adopter de bonnes pratiques de test

I can complete one of several todos
  Submit a todo  Adopter de bonnes pratiques de test
  Submit a todo  Comprendre le Keyword-Driven Testing
  Submit a todo  Automatiser des cas de test avec Robot Framework
  A new todo should be created  1  Adopter de bonnes pratiques de test
  A new todo should be created  2  Comprendre le Keyword-Driven Testing
  A new todo should be created  3  Automatiser des cas de test avec Robot Framework
  Complete a todo  2
  The todo should be completed  2
  The todo should be uncompleted  1
  The todo should be uncompleted  3

I can remove a todo
  Submit a todo  Choisir le bon type de framework de test
  Remove a todo  1
  The todo should be deleted  1

I can categorize some todos
  Submit a todo  Choisir un livre intéressant
  The todo should not be categorized  1
  Submit a todo  Marcher et faire du vélo avec mon chien  ${CATEGORIES.private}
  The todo 2 should be private
  Submit a todo  Faire un câlin avec mon chat
  The todo 3 should be private
  Submit a todo  Automatiser un cas de test de plus  ${CATEGORIES.professional}
  The todo 4 should be professional

I can read only one category of todos
  Submit a todo  Écrire un livre
  Submit a todo  Réaliser un spike de test  ${CATEGORIES.professional}
  Submit a todo  Tapisser le mur du salon  ${CATEGORIES.private}
  Submit a todo  Évaluer un framework de développement de test  ${CATEGORIES.professional}
  Should see todos  ${4}
  Check a category  ${CATEGORIES.private}
  Should see todos  ${1}  ${CATEGORIES.private}
  Check a category  ${CATEGORIES.professional}
  Should see todos  ${2}  ${CATEGORIES.professional}
  Check a category  ${CATEGORIES.all}
  Should see todos  ${4}

*** Keywords ***
Submit a todo
  [Arguments]  ${description}  ${category}=${None}
  Run keyword unless  '${category}' == '${None}'
  ...  Select options by  data-testid=select.category  text  ${category}
  Type text  data-testid=input.text.description  ${description}
  Click  text=Ajouter

A new todo should be created
  [Arguments]  ${number}  ${description}
  Get text  data-testid=text.todo_description-${number}  should be  ${description}${SPACE}
  Get checkbox state  data-testid=input.checkbox.done-${number}  should be  unchecked

Complete a todo
  [Arguments]  ${number}
  Check checkbox  data-testid=input.checkbox.done-${number}

The todo should be completed
  [Arguments]  ${number}
  Get checkbox state  data-testid=input.checkbox.done-${number}  should be  checked

The todo should be uncompleted
  [Arguments]  ${number}
  Get checkbox state  data-testid=input.checkbox.done-${number}  should be  unchecked

Remove a todo
  [Arguments]  ${number}
  Get element count  data-testid=button.remove_todo-${number}  should be  1
  Click  data-testid=button.remove_todo-${number}

The todo should be deleted
  [Arguments]  ${number}
  Get element count  data-testid=todo-${number}  should be  0

The todo should not be categorized
  [Arguments]  ${number}
  Get element count  data-testid=text.todo_category-${number}  should be  0

The todo ${number} should be ${category}
  Get text  data-testid=text.todo_category-${number}  should be  ${CATEGORIES.${category}}

Should see todos
  [Arguments]  ${expected_number_of_todos}  ${expected_category}=${CATEGORIES.all}
  ${actual_number_of_todos} =  Get element count  //*[@data-testid[starts-with(., "todo-")]]
  Should be equal as integers  ${actual_number_of_todos}  ${expected_number_of_todos}  Unexpected number of visible todos
  IF  '${expected_category}' != '${CATEGORIES.all}'
    ${actual_number_of_todos} =  Get element count  //*[@data-testid[starts-with(., "todo-")] and ./*[starts-with(@data-testid, "text.todo_category-") and text()="${expected_category}"]]
    Should be equal as integers  ${actual_number_of_todos}  ${expected_number_of_todos}  Unexpected number of todos in '${expected_category}'
  END

Check a category
  [Arguments]  ${category_to_display}
  Check checkbox  data-testid=input.radio.category_${category_to_display}
