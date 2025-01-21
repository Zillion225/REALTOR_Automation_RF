*** Settings ***
Resource    ../common/commonPO.robot

*** Keywords ***
Wait Until Search Result Appear
    [Arguments]    ${timeout}=15s
    Wait Until Page Contains Element    ${L_SEARCHRESULT_HEAD_COUNT}    timeout=${timeout}

Get Result Count
    [Arguments]    ${timeout}=15s
    Wait Until Page Contains Element    ${L_SEARCHRESULT_HEAD_COUNT}    timeout=${timeout}
    ${result_count_text}=    Get Text    ${L_SEARCHRESULT_HEAD_COUNT}
    ${result_count}=    commonPO.Convert Text to Number    ${result_count_text}
    RETURN    ${result_count}

Check No List Found
    Wait Until Element Is Visible    ${L_SEARCHRESULT_NO_LIST_FOUND_TEXT}
    Page Should Contain Element    ${L_SEARCHRESULT_NO_LIST_FOUND_TEXT}

Calculate Scroll Max Attemps
    [Arguments]    ${index}
    ${max_attempts}    Set Variable    ${index} * 1.5
    ${max_attempts}    Evaluate    round(${max_attempts})
    ${max_attempts}    Convert To Integer    ${max_attempts}
    RETURN    ${max_attempts}

Scroll Until Card Visible
    [Arguments]    ${card_index}
    # Caclate max attempt for scrolling
    ${max_attempts}=   Calculate Scroll Max Attemps    ${card_index}
    Log    ${max_attempts}

    # Create locator by replace {INDEX} with ${card_index}
    ${new_locator}=    Replace String    string=${L_SEARCHRESULT_CARD_INDEX}    search_for={INDEX}    replace_with=${card_index}
    Wait Until Element Is Visible    locator=${L_SEARCHRESULT_SCROLLVIEW}    timeout=15s

    ${is_find_item}=    commonPO.Scroll Until Element Located
    ...    scroll_container_locator=${L_SEARCHRESULT_SCROLLVIEW}
    ...    target_element_locator=${new_locator}
    ...    max_scroll_attempts=${max_attempts}
    
    RETURN    ${is_find_item}
    
Select Card
    [Arguments]    ${index}
    ${new_locator}=    Replace String    string=${L_SEARCHRESULT_CARD_INDEX}    search_for={INDEX}    replace_with=${index}
    Wait Until Element Is Visible    ${new_locator}
    Click Element    ${new_locator}

Verify Rooms Number
    [Arguments]    ${filter_rooms}    ${actual_display_rooms}
    ${plus_index}=    commonPO.Find Substring Index    search_text=${filter_rooms}    substring=+
    ${select_bedrooms_number}=    commonPO.Convert Text to Number    text=${filter_rooms}
    IF    $plus_index > -1
        Should Be True    ${actual_display_rooms} >= ${select_bedrooms_number}
    ELSE
        Should Be True    ${actual_display_rooms} == ${select_bedrooms_number}
    END