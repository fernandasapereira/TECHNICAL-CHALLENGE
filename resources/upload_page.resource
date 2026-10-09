*** Settings ***
Library     OperatingSystem
Library     DateTime
Resource    variables.resource
Resource    browser.resource

*** Variables ***
${FILE_INPUT}        id=file-upload
${UPLOAD_BUTTON}     id=file-submit
${SUCCESS_HEADER}    css=h3
${UPLOADED_FILES}    id=uploaded-files

*** Keywords ***
Open Upload Page
    Open Application Browser    ${UPLOAD_URL}

Prepare Timestamped Upload
    ${stamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${file_name}=    Set Variable    sample_upload_${stamp}.csv
    ${upload_dir}=    Join Path    ${EXECDIR}    output
    Create Directory    ${upload_dir}
    ${upload_path}=    Join Path    ${upload_dir}    ${file_name}
    Copy File    ${CSV_FILE}    ${upload_path}
    ${marker}=    Join Path    ${upload_dir}    last_uploaded_file.txt
    Remove File    ${marker}
    Set Suite Variable    ${UPLOAD_FILE_PATH}    ${upload_path}
    Set Suite Variable    ${UPLOAD_FILE_NAME}    ${file_name}

Save Uploaded File Name
    ${marker}=    Join Path    ${EXECDIR}    output    last_uploaded_file.txt
    Create File    ${marker}    ${UPLOAD_FILE_NAME}

Start Upload Suite
    Prepare Timestamped Upload
    Open Upload Page

Submit File For Upload
    [Arguments]    ${file_path}
    Choose File     ${FILE_INPUT}      ${file_path}
    Click Button    ${UPLOAD_BUTTON}

Page Should Show Uploaded File
    [Arguments]    ${file_name}
    Wait Until Page Contains            File Uploaded!       timeout=20s
    Wait Until Page Contains Element    ${UPLOADED_FILES}    timeout=20s
    Element Should Contain              ${SUCCESS_HEADER}    File Uploaded!
    Element Should Contain              ${UPLOADED_FILES}    ${file_name}
