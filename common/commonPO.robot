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

# Scroll Until Element Found
#     [Documentation]    Scrolls through the page until the specified element is found or the maximum number of attempts is reached.
#     ...                Arguments:
#     ...                - ${target_locator}: The locator of the target element to find.
#     ...                - ${max_scroll_attempts} (default=5): The maximum number of scroll attempts before failing.
#     ...                Behavior:
#     ...                - If the element is found within the specified attempts, the keyword stops scrolling.
#     ...                - If the element is not found, it raises an error indicating the element was not found.
#     [Arguments]    ${target_locator}    ${max_scroll_attempts}=5
#     ${attempts}=    Set Variable    0
#     ${is_page_contain_element}=    Set Variable    False

#     WHILE    ${attempts} < ${max_scroll_attempts}
#         ${is_page_contain_element}=    Run Keyword And Return Status    Page Should Contain Element    locator=${target_locator}
#         Run Keyword If    ${is_page_contain_element}    Exit For Loop
#         Swipe Up
#         ${attempts}=    Evaluate    ${attempts} + 1
#     END

#     IF    ${is_page_contain_element} == False
#         Fail    Element with locator "${target_locator}" not found after ${max_scroll_attempts} scroll attempts.
#     END

Swipe Up
    [Arguments]    ${scrollview_element_locator}    ${swipe_speed}=750
    ${element_size}=    Get Element Size    ${scrollview_element_locator}
    ${element_location}=    Get Element Location    ${scrollview_element_locator}
    
    # Calculate swipe coordinates
    ${center_x}=    Evaluate    ${element_location['x']} + (${element_size['width']} / 2)
    ${start_y}=     Evaluate    ${element_location['y']} + (${element_size['height']} * 0.7)
    ${end_y}=       Evaluate    ${element_location['y']} + (${element_size['height']} * 0.3)
    
    Swipe    ${center_x}    ${start_y}    ${center_x}    ${end_y}    ${swipe_speed}

Swipe Down
    [Arguments]    ${scrollview_element_locator}    ${swipe_speed}=750
    ${element_size}=    Get Element Size    ${scrollview_element_locator}
    ${element_location}=    Get Element Location    ${scrollview_element_locator}
    
    # Calculate swipe coordinates
    ${center_x}=    Evaluate    ${element_location['x']} + (${element_size['width']} / 2)
    ${start_y}=     Evaluate    ${element_location['y']} + (${element_size['height']} * 0.3)
    ${end_y}=       Evaluate    ${element_location['y']} + (${element_size['height']} * 0.7)
    
    Swipe    ${center_x}    ${start_y}    ${center_x}    ${end_y}    ${swipe_speed}

Calculate Swipe Position
    [Arguments]    ${scrollview_element_locator}    ${type}="DOWN"
    ${element_size}=    Get Element Size    ${scrollview_element_locator}
    ${element_location}=    Get Element Location    ${scrollview_element_locator}

    ${type}=    Convert To Upper Case    ${type}
    IF    "${type}" not in ["UP", "DOWN"]
        Fail    Invalid swipe type: ${type}. Use "UP" or "DOWN".
    END

    IF    "${type}" == "UP"
        ${start_y_multiplier}=    Set Variable    0.7
        ${end_y_multiplier}=    Set Variable    0.3
    ELSE
        ${start_y_multiplier}=    Set Variable    0.3
        ${end_y_multiplier}=    Set Variable    0.7
    END
    
    # Calculate swipe coordinates
    ${center_x}=    Evaluate    ${element_location['x']} + (${element_size['width']} / 2)
    ${start_y}=     Evaluate    ${element_location['y']} + (${element_size['height']} * ${start_y_multiplier})
    ${end_y}=       Evaluate    ${element_location['y']} + (${element_size['height']} * ${end_y_multiplier})
    
    ${dict}=    Create Dictionary    center_x=${center_x}    start_y=${start_y}    end_y=${end_y}
    
    RETURN    ${dict}