*** Settings ***
Library     OperatingSystem
Library     Collections
Library     String
Resource    variables.resource
Resource    browser.resource

*** Variables ***
${DOWNLOAD_LINK}    css=div.example a
${SAMPLE_FILE_NAME}    sample.txt

*** Keywords ***
Open Download Page
    Prepare Download Directory
    Open Application Browser    ${DOWNLOAD_URL}    ${DOWNLOAD_DIR}

Prepare Download Directory
    Create Directory    ${DOWNLOAD_DIR}
    @{files}=    List Files In Directory    ${DOWNLOAD_DIR}
    FOR    ${file}    IN    @{files}
        Remove File    ${DOWNLOAD_DIR}${/}${file}
    END

Download First Available File
    @{already_downloaded}=    List Files In Directory    ${DOWNLOAD_DIR}
    Wait Until Page Contains Element    ${DOWNLOAD_LINK}    timeout=15s
    Click Element    ${DOWNLOAD_LINK}
    ${file_name}=    Wait Until Keyword Succeeds    20s    1s    New Completed Download    @{already_downloaded}
    RETURN    ${file_name}

New Completed Download
    [Arguments]    @{already_downloaded}
    @{current}=    List Files In Directory    ${DOWNLOAD_DIR}
    FOR    ${name}    IN    @{current}
        ${is_partial}=    Run Keyword And Return Status    Should End With    ${name}    .crdownload
        Continue For Loop If    ${is_partial}
        ${already_there}=    Run Keyword And Return Status    List Should Contain Value    ${already_downloaded}    ${name}
        IF    not ${already_there}
            RETURN    ${name}
        END
    END
    Fail    No completed download appeared in the download folder.

Skip If Upload Did Not Pass
    ${marker}=    Join Path    ${EXECDIR}    output    last_uploaded_file.txt
    ${passed}=    Run Keyword And Return Status    File Should Exist    ${marker}
    IF    not ${passed}
        Skip    Upload CSV And Validate Result did not pass, so this test is skipped.
    END

Uploaded File Name
    ${marker}=    Join Path    ${EXECDIR}    output    last_uploaded_file.txt
    File Should Exist    ${marker}    The upload suite must run first and save the timestamped file name.
    ${file_name}=    Get File    ${marker}
    ${file_name}=    Strip String    ${file_name}
    RETURN    ${file_name}

Download File
    [Arguments]    ${file_name}
    ${link}=    Set Variable    xpath=//div[contains(@class,'example')]//a[normalize-space(.)='${file_name}']
    Wait Until Page Contains Element    ${link}    timeout=15s
    Click Element    ${link}

Downloaded File Should Exist And Not Be Empty
    [Arguments]    ${file_name}
    ${path}=    Join Path    ${DOWNLOAD_DIR}    ${file_name}
    Wait Until Keyword Succeeds    20s    1s    File Should Have Content    ${path}

File Should Have Content
    [Arguments]    ${path}
    File Should Exist    ${path}
    ${size}=    Get File Size    ${path}
    Should Be True    ${size} > 0

Downloaded File Content Should Match
    [Arguments]    ${file_name}    ${original_path}
    ${downloaded_path}=    Join Path    ${DOWNLOAD_DIR}    ${file_name}
    Wait Until Keyword Succeeds    20s    1s    File Should Have Content    ${downloaded_path}
    ${original}=      Get File    ${original_path}
    ${downloaded}=    Get File    ${downloaded_path}
    ${original}=      Replace String    ${original}      \r\n    \n
    ${downloaded}=    Replace String    ${downloaded}    \r\n    \n
    Should Be Equal    ${downloaded}    ${original}
