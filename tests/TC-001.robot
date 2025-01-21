*** Settings ***
Documentation    This test verifies the search functionality of the REALTOR.ca Real Estate & Homes app, including:
...              - Filtering by location, price, property type, and bedrooms.
...              - Accurate retrieval of property details and realtor contact information.

Resource         ../common/commonPO.robot
Resource         ../keywords/appPermissionPO.robot
Resource         ../keywords/realtorPO.robot
Resource         ../keywords/searchPO.robot
Resource         ../keywords/searchResultPO.robot
Resource         ../keywords/filterPO.robot
Resource         ../keywords/propertyInfoPO.robot
Resource         ../resources/datas/TC-001_Expect.robot

Test Teardown    commonPO.Custom Test Teardown

*** Variables ***
${APPIUM_SERVER_INDEX}                  0
${ALLOW_LOCATION_PERMISSION}            Y
${SEARCH_LOCATION}                      Ottawa
${SUGGESTION_INDEX}                     0
${FILTER_PROPERTY_TYPE}                 Residential
${FILTER_MAX_PRICE}                     800,000
${FILTER_BEDROOMS}                      3+
${RESULT_CARD_INDEX}                    2

*** Test Cases ***
TC-001 Verify Search Functionality
    [Documentation]    This test case checks if the app can correctly apply filters and display accurate property and realtor details.

    # Application Setup
    # Start the application and handle initial permissions
    commonPO.Start Application    appiumIndex=${APPIUM_SERVER_INDEX}    capability_file_path=${SETTING_DEFAULT_CAPABILITY_FILE_PATH}
    appPermissionPO.Bypass Permission Popup    allowType=${ALLOW_LOCATION_PERMISSION}
    realtorPO.Check Main Activity Is Loaded
    realtorPO.Dismiss Cookies Popup

    # Search with Keyword
    # Perform search for a specific location
    searchPO.Search with Keyword    ${SEARCH_LOCATION}
    searchPO.Wait Until Suggestion Box Appears
    ${suggestion_list}=    searchPO.Get Suggestion Box Items
    ${all_contain}=    commonPO.Verify Text In All List    list_text=${suggestion_list}    text=${SEARCH_LOCATION}    case_sensitive=False
    Should Be True    ${all_contain}
    searchPO.Select Specific Suggestions    ${SUGGESTION_INDEX}
    searchPO.Wait Until Selected Tag Appear    timeout=30

    # Apply Filters
    # Set up filters for the search
    filterPO.Open Filter
    filterPO.Wait Until Filter Appears
    filterPO.Click Filter Tab "For Sale"
    filterPO.Select Max Price    ${FILTER_MAX_PRICE}
    filterPO.Set Bedrooms to Value    ${FILTER_BEDROOMS}
    filterPO.Open Accordion Property Type
    filterPO.Select Property Type    ${FILTER_PROPERTY_TYPE}
    filterPO.Click Search

    # Verify Search Results
    # Check if the search results match the applied filters
    searchResultPO.Wait Until Search Result Appear
    searchResultPO.Scroll Until Card Visible    card_index=${RESULT_CARD_INDEX}
    searchResultPO.Select Card    index=${RESULT_CARD_INDEX}

    # Validate Property Information
    # Ensure property details are correct based on filter criteria
    ${property_info}=    propertyInfoPO.Get Property Information
    Log    ${property_info}

    ${max_price}=    commonPO.Convert Text to Number    text=${EXPECT_PINFO_PROPERY_PRICE_LESS_THAN_EQUAL}
    Should Be True    ${property_info}[PRICE] <= ${max_price}
    searchResultPO.Verify Rooms Number    filter_rooms=${FILTER_BEDROOMS}    actual_display_rooms=${property_info}[BEDROOMS]
    Should Be Equal As Strings    first=${property_info}[PROPERTY_TYPE]    second=${EXPECT_PINFO_PROPERY_TYPE}

    # Validate Realtor Information
    # Check if realtor contact details are displayed correctly
    propertyInfoPO.Scroll To REALTOR Information
    ${realtor_info}=    propertyInfoPO.Get REALTOR Information
    Log    ${realtor_info}