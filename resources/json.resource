*** Settings ***
Library    OperatingSystem
Library    Collections
Library    String

*** Variables ***
${JSON_1}    ${EXECDIR}${/}data${/}json1.json
${JSON_2}    ${EXECDIR}${/}data${/}json2.json
${JSON_3}    ${EXECDIR}${/}data${/}json3.json

*** Keywords ***
Load JSON From File
    [Arguments]    ${path}
    File Should Exist    ${path}
    ${text}=    Get File    ${path}
    ${data}=    Evaluate    json.loads($text)    json
    RETURN    ${data}

Load JSON Files 1 And 2
    ${json_1}=    Load JSON From File    ${JSON_1}
    ${json_2}=    Load JSON From File    ${JSON_2}
    Set Suite Variable    ${JSON_DATA_1}    ${json_1}
    Set Suite Variable    ${JSON_DATA_2}    ${json_2}

JSON Objects Should Be Equal
    [Arguments]    ${left}    ${right}
    ${left_text}=     Evaluate    json.dumps($left, sort_keys=True, indent=2)    json
    ${right_text}=    Evaluate    json.dumps($right, sort_keys=True, indent=2)    json
    Should Be Equal    ${left_text}    ${right_text}

JSON Fields Should Match
    [Arguments]    ${left}    ${right}    @{fields}
    FOR    ${field}    IN    @{fields}
        ${left_value}=     Get JSON Field    ${left}     ${field}
        ${right_value}=    Get JSON Field    ${right}    ${field}
        Should Be Equal    ${left_value}    ${right_value}    Field '${field}' does not match.
    END

JSON Field Should Differ
    [Arguments]    ${left}    ${right}    ${field}
    ${left_value}=     Get JSON Field    ${left}     ${field}
    ${right_value}=    Get JSON Field    ${right}    ${field}
    ${left_text}=      Evaluate    json.dumps($left_value, sort_keys=True)    json
    ${right_text}=     Evaluate    json.dumps($right_value, sort_keys=True)    json
    Should Not Be Equal    ${left_text}    ${right_text}    Field '${field}' is the same in both files.

Get JSON Field
    [Arguments]    ${data}    ${field}
    ${value}=    Set Variable    ${data}
    @{parts}=    Split String    ${field}    .
    FOR    ${part}    IN    @{parts}
        ${value}=    Get From Dictionary    ${value}    ${part}
    END
    RETURN    ${value}
