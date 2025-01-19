*** Settings ***
Resource    ../common/commonPO.robot

*** Keywords ***
Check Main Activity Is Loaded
    [Documentation]    Checks if the main activity is loaded.
    [Arguments]    ${timeout}=15s
    Wait Until Page Contains Element    ${L_TITLE_MESSAGE}    timeout=${timeout}
    Wait Until Page Does Not Contain    text=${T_TITLE_MESSAGE_WELCOME}    timeout=${timeout}
    Page Should Contain Element    ${L_TITLE_MESSAGE}    timeout=${timeout}
    Element Should Contain Text    locator=${L_TITLE_MESSAGE}    expected=${T_TITLE_MESSAGE}
    Page Should Contain Element    ${L_TITLE_MAP_AREA}    timeout=${timeout}
    Element Should Contain Text    locator=${L_TITLE_MAP_AREA}    expected=${T_TITLE_MAP_AREA}
    
Dismiss Cookies Popup
    Wait Until Page Contains Element    ${L_COOKIE_POPUP_BUTTON_DISMISS}
    Click Element    ${L_COOKIE_POPUP_BUTTON_DISMISS}