*** Settings ***
Resource    ../common/commonPO.robot

*** Keywords ***
Wait Until Property Information Page Display
    Wait Until Page Contains Element    ${L_PINFO_MLS_CODE}

Scroll To REALTOR Information
    commonPO.Scroll Until Element Located
    ...    scroll_container_locator=${L_PINFO_SCROLLVIEW}
    ...    target_element_locator=${L_PINFO_REALTOR_NAME}
    ...    max_scroll_attempts=10
    
    Wait Until Element Is Visible    locator=${L_PINFO_REALTOR_NAME}

Get REALTOR Information
    Wait Until Element Is Visible    ${L_PINFO_REALTOR_NAME}
    ${dict}=    Create Dictionary
    ${name}=    Get Text    ${L_PINFO_REALTOR_NAME}

    Set To Dictionary    ${dict}    NAME       ${name}
    
    RETURN    ${dict}

Get Property Information
    Wait Until Property Information Page Display
    ${dict}=    Create Dictionary
    ${mls_code}=    Get Text    locator=${L_PINFO_MLS_CODE}
    ${name}=    Get Text    locator=${L_PINFO_NAME}
    ${price_text}=    Get Text    locator=${L_PINFO_PRICE}
    ${price}=    commonPO.Convert Text to Number    text=${price_text}
    ${bedrooms}=    Get Text    locator=${L_PINFO_BEDROOMS}
    ${bathrooms}=    Get Text    locator=${L_PINFO_BATHROOMS}
    ${property_type}=    Get Text    locator=${L_PINFO_PROPERTY_TYPE}

    ${bedrooms}=    commonPO.Convert Text Number to Actual Numeric    text=${bedrooms}
    ${bathrooms}=    commonPO.Convert Text Number to Actual Numeric    text=${bathrooms}
   
    Set To Dictionary    ${dict}    MLS_CODE       ${mls_code}
    Set To Dictionary    ${dict}    NAME           ${name}
    Set To Dictionary    ${dict}    PRICE_TEXT     ${price_text}
    Set To Dictionary    ${dict}    PRICE          ${price}
    Set To Dictionary    ${dict}    BEDROOMS       ${bedrooms}
    Set To Dictionary    ${dict}    BATHROOMS      ${bathrooms}
    Set To Dictionary    ${dict}    PROPERTY_TYPE  ${property_type}

    RETURN    ${dict}

