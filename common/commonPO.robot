*** Settings ***
Library     AppiumLibrary
Library     JSONLibrary
Library     String
Library     Collections

Resource    ../resources/settingsPO.robot
Resource    ../resources/locatorsPO.robot
Resource    ../resources/expectPO.robot

*** Keywords ***
Start Application
    [Arguments]     ${appiumIndex}=0    ${capability_file_path}=${SETTING_DEFAULT_CAPABILITY_FILE_PATH}
    ${capability}=    Load Json From File    file_name=${capability_file_path}    encoding=utf-8
    Open Application    ${SETTING_APPIUM_SERVERS}[${appiumIndex}]    &{capability}
    Start Screen Recording

Custom Test Teardown
    Stop Screen Recording
    # Close Application

*** Keywords ***
Find Substring Index
    [Documentation]    Finds the index of the first occurrence of a substring within a text string.
    ...                Returns -1 if the substring is not found, similar to JavaScript's indexOf method.
    ...                - ${search_text}    The string to search within.
    ...                - ${substring}     The substring to search for.
    ...    *Return:* 
    ...    The index of the first occurrence of ${substring} in ${search_text} or -1 if not found.
    
    [Arguments]    ${search_text}    ${substring}
    ${find_index}=    Evaluate    '${search_text}'.find('${substring}')
    RETURN    ${find_index}

Get Text List From Locator
    [Arguments]    ${locator}
    [Documentation]    Retrieves text content from elements found by the given locator.
    ...                - ${locator}: CSS selector, XPath, or other locator strategy to find elements.
    ${elements}=    Get Webelements    locator=${locator}
    ${results}=    Convert Elements To Text List    ${elements}
    RETURN    ${results}

Convert Elements To Text List
    [Arguments]    ${elements}
    [Documentation]    Converts a list of web elements to a list of texts.
    ...                - ${elements}: List of web elements from which to extract text.
    ${return_list}=    Create List
    FOR    ${index}    ${element}    IN ENUMERATE    @{elements}
        ${text}=    Run Keyword And Ignore Error    Get Text    ${element}
        Run Keyword If    '${text}[0]' == 'FAIL'    Log    Failed to get text from element index: ${index}
        Run Keyword If    '${text}[0]' == 'PASS'    Append To List    ${return_list}    ${text}[1]
    END
    RETURN    ${return_list}

Locate Index of Text in List
    [Arguments]    ${list}    ${text}
    [Documentation]    Finds the index of a specific text within a list.
    ...                - ${list}: List to search through.
    ...                - ${text}: Text to find in the list.
    TRY
        ${index}=    Evaluate    ${list}.index('${text}')
        RETURN    ${index}
    EXCEPT
        Log    Keyword '${text}' not found in the list.
        RETURN    -1
    END

Get Absolute Value
    [Arguments]    ${number}
    [Documentation]    Returns the absolute value of a number.
    ...                - ${number}: Number to convert to its absolute value.
    ${absolute_value} =    Evaluate    abs(${number})
    RETURN    ${absolute_value}

Get Element Coordinates
    [Arguments]    ${locator}
    [Documentation]    Retrieves the top-left corner coordinates of an element.
    ...                - ${locator}: Locator used to find the element.
    ${location}=    Get Element Location    ${locator}
    ${x}=    Get From Dictionary    ${location}    x
    ${y}=    Get From Dictionary    ${location}    y
    Log    Element Coordinates -> Top-Left Corner: X=${x}, Y=${y}
    RETURN    ${x}    ${y}

Get Center Coordinates
    [Arguments]    ${locator}
    [Documentation]    Calculates and returns the center coordinates of an element.
    ...                - ${locator}: Locator for the element whose center coordinates are needed.
    ${x}    ${y}=    Get Element Coordinates    ${locator}
    ${x}    ${y}=    Get Element Coordinates    ${locator}
    ${size}=    Get Element Size    ${locator}
    ${width}=    Get From Dictionary    ${size}    width
    ${height}=    Get From Dictionary    ${size}    height
    ${center_x}=    Evaluate    ${x} + (${width} / 2)
    ${center_y}=    Evaluate    ${y} + (${height} / 2)
    Log    Element Coordinates -> Center: X=${center_x}, Y=${center_y}
    RETURN    ${center_x}    ${center_y}

Convert Text to Number
    [Arguments]    ${text}
    [Documentation]    Extracts and converts the first numeric value found in the text to a number.
    ...                - ${text}: String from which to extract a number. Can contain any characters.
    ${numeric_text}=    Replace String Using Regexp    ${text}    [^0-9\.\-]    ${EMPTY}
    IF    ${numeric_text}
        ${numeric}=    Convert To Number    ${numeric_text}
    ELSE
        ${numeric}=    Set Variable    ${EMPTY}
    END
    RETURN    ${numeric}

Convert Text Number to Actual Numeric
    [Arguments]    ${text}
    
    # Check if the input is a valid number
    ${is_number} =    Evaluate    '${text}'.isdigit()

    # If it's a valid number, convert it to an actual number
    IF    ${is_number}
        ${result} =    Convert To Number    ${text}

    # If it contains a plus sign, split and sum the parts
    ELSE
        ${contains_plus} =    Run Keyword And Return Status    Should Contain    ${text}    +
        IF    ${contains_plus}
            # Split the string by the plus sign
            @{parts} =    Split String    ${text}    +

            # Initialize the sum
            ${sum} =    Set Variable    0

            # Sum the parts
            FOR    ${part}    IN    @{parts}
                ${sum} =    Evaluate    ${sum} + ${part}
            END

            # Convert the sum to a number
            ${result} =    Convert To Number    ${sum}
        ELSE
            # If the input format is invalid, fail
            Fail    Invalid input format: ${text}
        END
    END

    # Return the result
    RETURN    ${result}

Scroll Scroview Until Item Is Visible
    [Arguments]    ${scrollview_locator}    ${item_locator}    ${end_marker_text}=$NOENDMARK$    ${scroll_offset_x}=0    ${scroll_offset_y}=-200    ${swipe_speed}=800    ${max_attempts}=20    ${sleep_time}=1s
    [Documentation]    Scrolls through a dropdown menu until the specified item is visible or until the end of the list is reached.
        ...                - ${dropdown_locator}: Locator of the dropdown element.
        ...                - ${item_locator}: Locator of the item to find.
        ...                - ${end_marker_text}: Text indicating the end of the dropdown list (optional).
        ...                - ${scroll_offset_x}, ${scroll_offset_y}: Scroll offset for swipe action.
        ...                - ${swipe_speed}: Speed of swipe action.
        ...                - ${max_attempts}: Maximum number of scroll attempts.
        ...                - ${sleep_time}: Time to wait between scroll actions.

    # Find the center of the dropdown element for scrolling
    ${center_coordinates} =    Get Center Coordinates    ${scrollview_locator}
    ${item_found} =    Set Variable    False

    # Check if the target item is already visible on the screen
    ${item_check_result} =    Run Keyword And Ignore Error    Page Should Contain Element    ${item_locator}
    IF    '${item_check_result}[0]' == 'PASS'
        Log    Target item is already visible: ${item_locator}
        RETURN    True
    END

    # If the target item is not found, initiate a swipe loop to continue searching until it is located.
    FOR    ${attempt}    IN RANGE    ${max_attempts}

        Log    Scrolling through dropdown to search for the target item
        # Perform a scroll/swipe action
        Swipe    ${center_coordinates[0]}    ${center_coordinates[1] + 100}    ${center_coordinates[0] + ${scroll_offset_x}}    ${center_coordinates[1] + ${scroll_offset_y}}    ${swipe_speed}

        # Ensure the dropdown menu remains on the screen to avoid crashes
        Page Should Contain Element    ${scrollview_locator}
        
        # Check if the target item is now visible
        ${item_check_result} =    Run Keyword And Ignore Error    Page Should Contain Element    ${item_locator}

        # Check if the end of the dropdown is reached (optional)
        ${end_marker_check_result} =    Run Keyword And Ignore Error    Page Should Contain Text    ${end_marker_text}

        # If the target item is visible, log and exit the loop
        IF    '${item_check_result}[0]' == 'PASS'
            Log    Target item found: ${item_locator}
            ${item_found} =    Set Variable    True
            BREAK

        # If the end marker is visible, log and exit the loop
        ELSE IF    '${end_marker_check_result}[0]' == 'PASS'
            Log    End of dropdown reached: ${end_marker_text}
            BREAK

        END

        # Wait briefly to let the UI update before the next scroll
        Sleep    ${sleep_time}
    END

    # Return whether the target item was found
    RETURN    ${item_found}
    
Adjust Display Value to Target
    [Arguments]
    ...    ${display_text_locator}
    ...    ${existing_items_list}
    ...    ${target_text}
    ...    ${increase_button_locator}
    ...    ${decrease_button_locator}
    ...    ${wait_between_clicks}=0.5s
    [Documentation]    Adjusts the displayed value to match a target text by clicking increase or decrease buttons.
    ...                - ${display_text_locator}: Locator of the text display element.
    ...                - ${existing_items_list}: List of possible values.
    ...                - ${target_text}: The target text to achieve.
    ...                - ${increase_button_locator}, ${decrease_button_locator}: Locators for buttons to adjust value.
    ...                - ${wait_between_clicks}: Time to wait between button clicks.

    # Get current text and calculate adjustments needed
    ${current_text}=    Get Text    locator=${display_text_locator}
    ${current_index}=    Locate Index of Text in List    ${existing_items_list}    ${current_text}
    ${target_index}=    Locate Index of Text in List    ${existing_items_list}    ${target_text}
    ${difference}=    Evaluate    ${target_index} - ${current_index}
    Log    Difference in indices: ${difference}

    ${absolute_difference}=    Get Absolute Value    ${difference}
    IF    ${difference} > 0
        Repeat Click    ${increase_button_locator}    ${absolute_difference}    ${wait_between_clicks}
    ELSE
        Repeat Click    ${decrease_button_locator}    ${absolute_difference}    ${wait_between_clicks}
    END

Repeat Click
    [Arguments]    ${locator}    ${times}    ${wait_time}=0.5s
    [Documentation]    Repeats clicking on an element a specified number of times.
    ...                - ${locator}: Locator of the element to click.
    ...                - ${times}: Number of clicks.
    ...                - ${wait_time}: Time to wait between clicks.

    FOR    ${i}    IN RANGE    ${times}
        Click Element    locator=${locator}
        Sleep    ${wait_time}
    END
    
*** Keywords ***
Verify Text In All List
    [Documentation]    Checks if a given text exists in all elements of the provided list.
    ...                - If case_sensitive is False, the comparison is case-insensitive.
    ...                - Returns True if the text is in all items, False otherwise.
    [Arguments]    ${list_text}    ${text}    ${case_sensitive}=True
    
    # Initialize the result to True; we'll set it to False if we find a mismatch
    ${result}    Set Variable    ${True}
    
    # Loop through each item in the list
    FOR    ${item}    IN    @{list_text}
        # Initially, set comparison variables to the current item and target text
        ${compare_text}    Set Variable    ${item}
        ${compare_target}    Set Variable    ${text}
        
        # If case sensitivity is not required, convert both text and item to lowercase
        IF    not ${case_sensitive}
            ${compare_text}    Convert To Lowercase    ${item}
            ${compare_target}    Convert To Lowercase    ${text}
        END
        
        # Check if the target text is not within the current item
        IF    '${compare_target}' not in '${compare_text}'
            # If text is not found, set result to False and exit loop
            ${result}    Set Variable    ${False}
            BREAK
        END
    END
    
    # Return the final result of the check
    RETURN    ${result}

Scroll Until Element Located 
    [Documentation]    Scrolls through a scrollable container until the specified target element is visible or until the maximum number of attempts is reached.
        ...                - ${scroll_container_locator}: Locator for the scrollable container (e.g., a list or scrollview).
        ...                - ${target_element_locator}: Locator for the target element to find.
        ...                - ${max_scroll_attempts}: Maximum number of scroll attempts before failing.
        ...                - ${swipe_duration}: (Optional) Duration of the swipe action in milliseconds. Default is 600ms.
        ...                - ${wait_after_swipe}: (Optional) Wait time after each swipe. Default is 0.2 seconds.
    [Arguments]    
    ...    ${scroll_container_locator}    # Locator for the scrollable container (e.g., a list or a scrollview).
    ...    ${target_element_locator}      # Locator for the target element to find.
    ...    ${max_scroll_attempts}         # Maximum number of scroll attempts before failing.
    ...    ${swipe_duration}=600          # (Optional) Duration of the swipe action in milliseconds. Default is 600ms.
    ...    ${wait_after_swipe}=0.2s       # (Optional) Wait time after each swipe. Default is 0.2 seconds.

    # Initialize the flag to indicate whether the target element is found.
    ${element_found} =    Set Variable    False

    # Check if the target element is already visible without scrolling.
    ${element_already_visible} =    Run Keyword And Return Status    Page Should Contain Element    ${target_element_locator}
    IF    ${element_already_visible}
        Log    Target element already visible: ${target_element_locator}
        RETURN    ${True}    # Exit if the target element is already visible.
    END

    # Calculate the swipe coordinates for scrolling within the container.
    ${swipe_coordinates} =    Calculate Swipe Y Position    scrollview_element_locator=${scroll_container_locator}    swipe_direction=DOWN

    # Start scrolling for a maximum number of attempts.
    FOR    ${attempt}    IN RANGE    ${max_scroll_attempts}
        # Ensure the scrollable container is present to prevent the app from crashing.
        Page Should Contain Element    ${scroll_container_locator}

        # Perform the swipe gesture using the calculated coordinates.
        Swipe    
        ...    start_x=${swipe_coordinates}[CENTER_X]    
        ...    start_y=${swipe_coordinates}[START_Y]
        ...    offset_x=${swipe_coordinates}[CENTER_X]
        ...    offset_y=${swipe_coordinates}[END_Y]
        ...    duration=${swipe_duration}

        # Check if the target element becomes visible after the swipe.
        ${element_already_visible} =    Run Keyword And Return Status    Page Should Contain Element    ${target_element_locator}

        IF    ${element_already_visible}
            Log    Target element visible after ${attempt} attempts: ${target_element_locator}
            BREAK    # Exit the loop if the target element is found.
        END

        # Wait for a short duration before the next swipe.
        Sleep    ${wait_after_swipe}
    END

    # If the target element is still not found after all attempts, raise an error.
    IF    ${element_already_visible} == False
        Fail    Element with locator "${target_element_locator}" not found after ${max_scroll_attempts} scroll attempts.
    END

    # Return whether the target element was found.
    RETURN    ${element_already_visible}

Swipe Up
    [Arguments]    ${scrollview_element_locator}    ${swipe_speed}=750
    ${element_size}=    Get Element Size    ${scrollview_element_locator}
    ${element_location}=    Get Element Location    ${scrollview_element_locator}
    
    # Calculate swipe coordinates
    ${center_x}=    Evaluate    ${element_location['x']} + (${element_size['width']} / 2)
    ${start_y}=     Evaluate    ${element_location['y']} + (${element_size['height']} * 0.2)
    ${end_y}=       Evaluate    ${element_location['y']} + (${element_size['height']} * 0.9)
    
    Swipe    ${center_x}    ${start_y}    ${center_x}    ${end_y}    ${swipe_speed}

Swipe Down
    [Arguments]    ${scrollview_element_locator}    ${swipe_speed}=750
    ${element_size}=    Get Element Size    ${scrollview_element_locator}
    ${element_location}=    Get Element Location    ${scrollview_element_locator}
    
    # Calculate swipe coordinates
    ${center_x}=    Evaluate    ${element_location['x']} + (${element_size['width']} / 2)
    ${start_y}=     Evaluate    ${element_location['y']} + (${element_size['height']} * 0.9)
    ${end_y}=       Evaluate    ${element_location['y']} + (${element_size['height']} * 0.2)
    
    Swipe    ${center_x}    ${start_y}    ${center_x}    ${end_y}    ${swipe_speed}

Calculate Swipe Y Position
    [Arguments]    ${scrollview_element_locator}    ${swipe_direction}="DOWN"
    ${element_size}=    Get Element Size    ${scrollview_element_locator}
    ${element_location}=    Get Element Location    ${scrollview_element_locator}

    ${swipe_direction}=    Convert To Upper Case    ${swipe_direction}
    IF    "${swipe_direction}" not in ["UP", "DOWN"]
        Fail    Invalid swipe type: ${swipe_direction}. Use "UP" or "DOWN".
    END

    IF    "${swipe_direction}" == "UP"
        ${start_y_multiplier}=    Set Variable    0.2
        ${end_y_multiplier}=    Set Variable    0.9
    ELSE
        ${start_y_multiplier}=    Set Variable    0.9
        ${end_y_multiplier}=    Set Variable    0.2
    END
    
    # Calculate swipe coordinates
    ${center_x}=    Evaluate    ${element_location['x']} + (${element_size['width']} / 2)
    ${start_y}=     Evaluate    ${element_location['y']} + (${element_size['height']} * ${start_y_multiplier})
    ${end_y}=       Evaluate    ${element_location['y']} + (${element_size['height']} * ${end_y_multiplier})
    
    ${dict}=    Create Dictionary    CENTER_X=${center_x}    START_Y=${start_y}    END_Y=${end_y}
    
    RETURN    ${dict}