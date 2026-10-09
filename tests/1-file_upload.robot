*** Settings ***
Documentation     Open the upload page, upload files and validate the upload. Close the browser after all tests.
Resource          ../resources/upload_page.resource
Suite Setup       Start Upload Suite
Suite Teardown     Close Application Browser

*** Test Cases ***
Upload CSV And Validate Result
    [Tags]    smoke    regression
    [Documentation]    Submit the CSV with the current date and time in the file name, and check the success message and that name.
    Submit File For Upload           ${UPLOAD_FILE_PATH}
    Page Should Show Uploaded File      ${UPLOAD_FILE_NAME}
    Save Uploaded File Name
