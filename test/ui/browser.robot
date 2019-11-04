*** Settings ***
Library         Browser

*** Test Cases ***
How to open a new browser instance for quick experiments or debugging sessions
  Open browser

How to open a new headless browser instance in a regular way
  New browser

How to go to Google.fr
  New browser
  New page  url=https://google.fr

How to take a screenshot
  New browser
  New page  url=https://google.fr
  Take screenshot  selector=xpath=/html
