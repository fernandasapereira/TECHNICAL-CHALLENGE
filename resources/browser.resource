*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem
Resource    variables.resource

*** Keywords ***
Open Application Browser
    [Arguments]    ${url}    ${download_dir}=${NONE}
    IF    $download_dir is not None
        ${options}=    Build Chrome Options    ${download_dir}
        Open Browser    ${url}    ${BROWSER}    options=${options}
    ELSE
        Open Browser    ${url}    ${BROWSER}
    END
    Maximize Browser Window

Build Chrome Options
    [Arguments]    ${download_dir}
    ${absolute_dir}=    Normalize Path    ${download_dir}
    Create Directory    ${absolute_dir}
    ${prefs}=    Create Dictionary
    ...    download.default_directory=${absolute_dir}
    ...    download.prompt_for_download=${False}
    ...    download.directory_upgrade=${True}
    ...    safebrowsing.enabled=${True}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    RETURN    ${options}

Close Application Browser
    Close All Browsers
