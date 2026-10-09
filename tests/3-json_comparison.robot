*** Settings ***
Documentation     Read JSON files and validate full matches, partial matches, and a field difference.
Resource          ../resources/json.resource
Suite Setup       Load JSON Files 1 And 2

*** Test Cases ***
JSON Files Contain The Same Keys And Values
    [Tags]    smoke    regression
    [Documentation]    Full comparison of data/json1.json and data/json2.json.
    JSON Objects Should Be Equal    ${JSON_DATA_1}    ${JSON_DATA_2}

Selected JSON Fields Are Equal
    [Tags]    regression
    [Documentation]    Partial comparison of suite and environment between json1.json and json3.json. The checks field differs and is not compared.
    ${JSON_DATA_3}=    Load JSON From File    ${JSON_3}
    JSON Fields Should Match    ${JSON_DATA_1}    ${JSON_DATA_3}    suite    environment

JSON Checks Differ Between File 1 And File 3
    [Tags]    regression
    [Documentation]    Passes when the checks object in json1.json is different from json3.json.
    ${JSON_DATA_3}=    Load JSON From File    ${JSON_3}
    JSON Field Should Differ    ${JSON_DATA_1}    ${JSON_DATA_3}    checks
