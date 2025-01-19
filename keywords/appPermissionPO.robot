*** Settings ***
Resource    ../common/commonPO.robot

*** Keywords ***
Bypass Permission Popup
    [Documentation]    Handles the permission popup for device location access.
    ...    Available options for the parameter `allowType`:
    ...    - Y: Select "While Using the App"
    ...    - N: Select "Don't Allow"
    ...    - O: Select "Only This Time"
    ...
    ...    Arguments:
    ...    - ${allowType}: The type of permission to select (default: Y).
    ...    - ${timeout}: Timeout to wait for the popup to appear (default: 15 seconds).
    [Arguments]    ${allowType}=Y    ${timeout}=15s    ${wait_for_popup}=20s

    # Convert allowType to uppercase to make it case-insensitive
    ${allowType_upper}=    Convert To Uppercase    ${allowType}
    
    # Check if the permission popup is visible within the specified timeout
    ${popup_visible}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${L_PERMISSION_DEVICE_LOCATION_POPUP_MESSAGE}    timeout=${wait_for_popup}

    # If the popup is visible, handle it based on the selected allowType
    IF    ${popup_visible}
        # Verify the popup contains the expected text
        Element Should Contain Text    locator=${L_PERMISSION_DEVICE_LOCATION_POPUP_MESSAGE}    expected=${T_PERMISSION_DEVICE_LOCATION_POPUP}

        # Handle the user's permission selection
        IF    '${allowType_upper}' == 'Y'
            Click Element    ${L_PERMISSION_DEVICE_LOCATION_POPUP_ALLOW}
        ELSE IF    '${allowType_upper}' == 'O'
            Click Element    ${L_PERMISSION_DEVICE_LOCATION_POPUP_ONLY_THIS_TIME}
        ELSE
            Click Element    ${L_PERMISSION_DEVICE_LOCATION_POPUP_DENY}
        END
    END

    Wait Until Page Does Not Contain Element   ${L_PERMISSION_DEVICE_LOCATION_POPUP_MESSAGE}    timeout=${timeout}
    Page Should Not Contain Element    ${L_PERMISSION_DEVICE_LOCATION_POPUP_MESSAGE}    timeout=${timeout}
