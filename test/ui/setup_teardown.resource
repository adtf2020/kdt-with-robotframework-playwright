*** Settings ***
Library         Browser

*** Keywords ***
Prepare the test suite
  ${playwright_delay} =  Get variable value  ${SPEED}  0:00:00
  New browser  headless=${False}  slowMo=${playwright_delay}
  New context  viewport={'width': 600, 'height': 300}
  New page  url=http://localhost:9090
  Set browser timeout  10 seconds

Prepare the test case
  Get title  should be  Tout Doux

Clean up the test case
  Reload

Clean up the test suite
  No operation
