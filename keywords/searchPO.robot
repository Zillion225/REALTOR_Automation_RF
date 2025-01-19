*** Settings ***
Resource    ../common/commonPO.robot

*** Keywords ***
Search with Keyword
    [Arguments]    ${search_text}
    Click Element    ${L_SEARCH_BAR}
    Input Text    ${L_SEARCH_BAR}    ${search_text}

Wait Until Suggestion Box Appears
    [Arguments]    ${timeout}=15s
    Wait Until Page Contains Element    ${L_SEARCH_SUGGESTION_BOX}    timeout=${timeout}
    Wait Until Page Contains Element    ${L_SEARCH_SUGGESTION_NEAR_YOU}    timeout=${timeout}

Get Suggestion Box Items
    ${return_list}=    commonPO.Get Text List From Locator    ${L_SEARCH_SUGGESTION_ITEM}
    RETURN    ${return_list}

Get Suggestion Box Items (All Items)
    ${suggestion_items}=    Get Webelements    locator=${L_SEARCH_SUGGESTION_ALL_ITEMS}
    ${return _list}=    commonPO.Convert Elements To Text List    ${suggestion_items}
    RETURN    ${return_list}

Select Specific Suggestions
    [Arguments]    ${select_index}
    ${suggestion_items}=    Get Webelements    ${L_SEARCH_SUGGESTION_ITEM}
    ${item_count}=    Get Length    ${suggestion_items}
    IF    ${item_count} == 0
        Fail    No suggestion items found
    END
    IF    ${select_index} >= ${item_count}
        Fail    Index is out of range
    END
    Click Element    ${suggestion_items[${select_index}]}

Wait Until Selected Tag Appear
    [Arguments]    ${timeout}=15s
    Wait Until Element Is Visible    ${L_SEARCH_TEXTBOX_TAG}    timeout=${timeout}
