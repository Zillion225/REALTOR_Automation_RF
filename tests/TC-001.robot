*** Settings ***
Documentation     This is a automated test case for REALTOR.ca Real Estate & Homes app

Resource    ../common/commonPO.robot
Resource    ../keywords/appPermissionPO.robot
Resource    ../keywords/realtorPO.robot
Resource    ../keywords/searchPO.robot
Resource    ../keywords/searchResultPO.robot
Resource    ../keywords/filterPO.robot
Resource    ../keywords/propertyInfoPO.robot

Resource    ../resources/datas/TC-001_Expect.robot

Test Teardown    commonPO.Custom Test Teardown

*** Variables ***
${APPIUM_SERVER_INDEX}    0
${DEVICE_LOCATION_PERMISSION_ALLOW_TYPE}    Y
${SEARCH_KEYWORD}    Ottawa
${SELECT_SUGGESTION_INDEX}    0
${SELECT_PROPERTY_TYPE}    Residential
${SELECT_FILTER_MAX_PRICE}    800,000
${SELECT_FILTER_SELECT_BEDROOMS}    3+
${SELECT_RESULT_CARD_INDEX}    2

*** Test Cases ***
TC-001
    [Documentation]    This is a test case to verify the search functionality
    commonPO.Start Application    appiumIndex=${APPIUM_SERVER_INDEX}    capability_file_path=${SETTING_DEFAULT_CAPABILITY_FILE_PATH}

    # By Pass Permission Popup
    appPermissionPO.Bypass Permission Popup    allowType=${DEVICE_LOCATION_PERMISSION_ALLOW_TYPE}
    # Check Main Activity is loaded
    realtorPO.Check Main Activity Is Loaded
    # Dismiss Cookies Popup
    realtorPO.Dismiss Cookies Popup

    # Search with keyword
    searchPO.Search with Keyword    ${SEARCH_KEYWORD}
    searchPO.Wait Until Suggestion Box Appears
    # Check all suggesion item cointain word from ${SEARCH_KEYWORD}
    ${suggesion_list}=    searchPO.Get Suggestion Box Items
    ${all_contain}=    commonPO.Verify Text In All List    list_text=${suggesion_list}    text=${SEARCH_KEYWORD}    case_sensitive=False
    Should Be True    ${all_contain}
    # Select Suggestions
    searchPO.Select Specific Suggestions    ${SELECT_SUGGESTION_INDEX}
    # Wait until search results appear
    searchPO.Wait Until Selected Tag Appear    timeout=30
    
    # Open Filter
    filterPO.Open Filter
    filterPO.Wait Until Filter Appears
    # Click Tab For Sale
    filterPO.Click Filter Tab "For Sale"
    filterPO.Choose Max Price    ${SELECT_FILTER_MAX_PRICE}
    filterPO.Set Bedrooms to Value    ${SELECT_FILTER_SELECT_BEDROOMS}
    # Open Accordion Box
    filterPO.Open Accordion Property Type
    filterPO.Select Property Type        ${SELECT_PROPERTY_TYPE}
    filterPO.Click Search
    
    # Search Result Page
    searchResultPO.Wait Until Search Result Appear
    searchResultPO.Scroll Until Card Visible    index=${SELECT_RESULT_CARD_INDEX}
    searchResultPO.Select Card    index=${SELECT_RESULT_CARD_INDEX}

    # Property Information Page
    ${property_info}=    propertyInfoPO.Get Property Information
    Log    ${property_info}

    # Verify Property Price is less than ${SELECT_FILTER_MAX_PRICE}
    Should Be True    ${property_info}[PRICE] >= ${SELECT_FILTER_MAX_PRICE}

    # Verify Property Bedrooms
    searchResultPO.Verify Rooms Number    filter_rooms=${SELECT_FILTER_SELECT_BEDROOMS}    actual_display_rooms=${property_info}[BEDROOMS]
    # Go to REALTOR Information    
    propertyInfoPO.Scroll To REALTOR Information
    ${realtor_info}=    propertyInfoPO.Get REALTOR Information
    Log    ${realtor_info}
    Sleep    3s