*** Settings ***
Documentation     
...    Open the download page, test the download of files and validate the results locally.
...    Close the browser after all tests.
Resource          ../resources/download_page.resource
Suite Setup       Open Download Page
Suite Teardown     Close Application Browser

*** Test Cases ***
Download First Available File And Validate It Locally
    [Tags]    smoke    regression
    [Documentation]    Download the first available file, and check that it exists and is not empty.
    ${file_name}=    Download First Available File
    Downloaded File Should Exist And Not Be Empty    ${file_name}

Download Sample Txt And Validate It Locally
    [Tags]    regression
    [Documentation]    Download the sample.txt file, and check that it exists in the download folder and is not empty.
    Download File     ${SAMPLE_FILE_NAME}
    Downloaded File Should Exist And Not Be Empty     ${SAMPLE_FILE_NAME}

Download Uploaded CSV And Validate Content
    [Tags]    regression
    [Setup]    Skip If Upload Did Not Pass
    [Documentation]    Download the timestamped CSV from the upload suite and check that its content matches the uploaded file. This test is skipped when the upload test did not pass.
    ${file_name}=    Uploaded File Name
    ${original}=    Join Path    ${EXECDIR}    output    ${file_name}
    Download File    ${file_name}
    Downloaded File Content Should Match    ${file_name}    ${original}
