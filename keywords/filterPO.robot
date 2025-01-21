*** Settings ***
Resource    ../common/commonPO.robot

*** Keywords ***
Open Filter
    Wait Until Page Contains Element    ${L_FILTER_BUTTON}
    Click Element    ${L_FILTER_BUTTON}

Wait Until Filter Appears
    [Arguments]    ${timeout}=15s
    Wait Until Page Contains Element    ${L_FILTER_PAGE_TITLE}    timeout=${timeout}
    Element Text Should Be    locator=${L_FILTER_PAGE_TITLE}    expected=${T_FILTER_PAGE_TITLE}

Click Filter Tab "For Sale"
    Click Element    ${L_FILTER_TABS_FORSALE}

Click Filter Tab "For Rent"
    Click Element    ${L_FILTER_TABS_FORRENT}

Click Filter Tab "Sold"
    Click Element    ${L_FILTER_TABS_SOLD}

Click Filter Tab "Lease"
    Click Element    ${L_FILTER_TABS_LEASE}

Select Max Price
    [Arguments]    ${price}
    Click Element    ${L_FILTER_RANGE_MAX_DROPDOWN}
    Wait Until Element Is Visible    ${L_FILTER_RANGE_MAX_DROPDOWN_SCROLLVIEW}

    ${new_locator} =    Replace String    ${L_FILTER_RANGE_MAX_DROPDOWN_ITEM}    {PRICE}    ${price}
    ${is_find_item}=    commonPO.Scroll Until Element Located
    ...    scroll_container_locator=${L_FILTER_RANGE_MAX_DROPDOWN_SCROLLVIEW}
    ...    target_element_locator=${new_locator}
    ...    max_scroll_attempts=20

    IF    ${is_find_item}
        Click Element    ${new_locator}
    ELSE
        Fatal Error    Cannot find the item: ${price}
    END

Click Search
    Wait Until Element Is Visible    ${L_FILTER_SEARCH_BUTTON}
    Click Element    ${L_FILTER_SEARCH_BUTTON}

Click Clear All
    Wait Until Element Is Visible    ${L_FILTER_CLEAR_ALL_BUTTON}
    Click Element    ${L_FILTER_CLEAR_ALL_BUTTON}

Get Current Bedrooms Value
    RETURN    Get Text    locator=${L_FILTER_STEP_BEDROOMS_TEXT}

Click Accordion Property Type
    [Documentation]    Clicks the property type accordion header to toggle its state.
    Wait Until Element Is Visible    ${L_FILTER_ACCORDION_HEAD_PROPERTY_TYPE}
    Click Element    ${L_FILTER_ACCORDION_HEAD_PROPERTY_TYPE}

Open Accordion Property Type
    [Documentation]    Opens the property type accordion if it's not already open.
    Wait Until Element Is Visible    ${L_FILTER_ACCORDION_HEAD_PROPERTY_TYPE}
    ${element_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${L_FILTER_ACCORDION_BODY_PROPERTY_TYPE}
    Run Keyword If    not ${element_exists}    Click Accordion Property Type

Close Accordion Property Type
    [Documentation]    Closes the property type accordion if it's currently open.
    Wait Until Element Is Visible    ${L_FILTER_ACCORDION_HEAD_PROPERTY_TYPE}
    ${element_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${L_FILTER_ACCORDION_BODY_PROPERTY_TYPE}
    Run Keyword If    ${element_exists}    Click Accordion Property Type

Select Property Type
    [Arguments]    ${select_text}
    Wait Until Page Contains Element    ${L_FILTER_ACCORDION_BODY_PROPERTY_TYPE}
    ${locator}=    Replace String    ${L_FILTER_ACCORDION_ITEM}    {TEXT}    ${select_text}
    Click Element    ${locator}

Set Bedrooms to Value
    [Documentation]    `text` ที่รองรับคือ Any    1    1+    2    2+    3    3+    4    4+    5    5+
    [Arguments]    ${text}
    commonPO.Adjust Display Value to Target
    ...    display_text_locator=${L_FILTER_STEP_BEDROOMS_TEXT}    
    ...    existing_items_list=${FILTER_STEP_BEDROOMS}    
    ...    target_text=${text}
    ...    increase_button_locator=${L_FILTER_STEP_BEDROOMS_PLUS_BUTTON}
    ...    decrease_button_locator=${L_FILTER_STEP_BEDROOMS_MINUS_BUTTON}