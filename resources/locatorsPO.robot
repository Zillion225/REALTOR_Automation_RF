*** Variables ***
# Permission Pop Up
${L_PERMISSION_DEVICE_LOCATION_POPUP_MESSAGE}   id=com.android.permissioncontroller:id/permission_message
${L_PERMISSION_DEVICE_LOCATION_POPUP_ALLOW}    id=com.android.permissioncontroller:id/permission_allow_foreground_only_button
${L_PERMISSION_DEVICE_LOCATION_POPUP_ONLY_THIS_TIME}    id=com.android.permissioncontroller:id/permission_allow_one_time_button
${L_PERMISSION_DEVICE_LOCATION_POPUP_DENY}    com.android.permissioncontroller:id/permission_deny_button

# Cookie Pop Up
${L_COOKIE_POPUP_BUTTON_DISMISS}    id=x:id/banner.dismiss_button

# Search Screen (Home Screen)
${L_TITLE_MESSAGE}    id=x:id/page.listings.near_you.text

# MAP Area
${L_TITLE_MAP_AREA}    id=x:id/page.listings.listings.handle.text

# Search Bar
${L_SEARCH_BAR}    id=x:id/page.listings.search_textbox.textbox
${L_SEARCH_SUGGESTION_BOX}    id=x:id/page.property_search.search_suggestions
${L_SEARCH_SUGGESTION_NEAR_YOU}    id=x:id/page.property_search.search_suggestions.user_location
${L_SEARCH_SUGGESTION_GROUP}    id=x:id/page.property_search.search_suggestions.locations
${L_SEARCH_SUGGESTION_GROUP_LOCATIONS}    xpath=//android.view.ViewGroup[@content-desc="LOCATIONS"]
${L_SEARCH_SUGGESTION_GROUP_LISTINGS}    xpath=//android.view.ViewGroup[@content-desc="LISTINGS"]
${L_SEARCH_SUGGESTION_ITEM}    id=x:id/page.property_search.search_suggestions.item
${L_SEARCH_SUGGESTION_ITEM_FOR_SELECT}    xpath=//android.widget.TextView[@resource-id="x:id/page.property_search.search_suggestions.item"]
${L_SEARCH_SUGGESTION_ITEM_FOR_SELECT_VIA_TEXT}    xpath=//android.widget.TextView[@resource-id="x:id/page.property_search.search_suggestions.item" and @text="{SEARCH_TEXT}"]
${L_SEARCH_SUGGESTION_ALL_ITEMS}    xpath=//android.widget.ScrollView[@content-desc="x:id/page.property_search.search_suggestions"]/android.view.ViewGroup/android.view.ViewGroup[position() > 1]//android.widget.TextView

${L_SEARCH_TEXTBOX_TAG}    id=x:id/page.listings.search_textbox.textbox
${L_SEARCH_TEXTBOX_TAG_CLEAR}    xpath=//android.view.ViewGroup[@content-desc="x:id/icon.clear.filled"]

# Search Result
${L_SEARCHRESULT_HEAD_COUNT}    id=x:id/page.listings.header.count.text
${L_SEARCHRESULT_NO_LIST_FOUND_TEXT}    id=x:id/page.listings.no_listings.text
${L_SEARCHRESULT_START_NEW_SEARCH_BUTTON}    id=x:id/view.cards.new_search.text
${L_SEARCHRESULT_SCROLLVIEW}    xpath=//android.widget.ScrollView
${L_SEARCHRESILT_CARD}    id=x:id/listing.price_card
${L_SEARCHRESULT_CARD_INDEX}    id=x:id/listing_browser.vertical.large_card.{INDEX}
${L_SEARCHRESILT_CARD_NAME}    id=x:id/listing_browser.vertical.large_card.{INDEX}.address.text
# Filter
${L_FILTER_BUTTON}    id=x:id/page.listings.filters
${L_FILTER_PAGE_TITLE}    id=x:id/page.property_search.title
${L_FILTER_SEARCH_BUTTON}    id=x:id/page.property_search.search_button
${L_FILTER_CLEAR_ALL_BUTTON}    id=x:id/page.property_search.clear_button.text
${L_FILTER_TABS_FORSALE}    xpath=//android.view.ViewGroup[@resource-id="x:id/segment_selector"]//android.view.ViewGroup[@content-desc="For Sale"]
${L_FILTER_TABS_FORRENT}    xpath=//android.view.ViewGroup[@resource-id="x:id/segment_selector"]//android.view.ViewGroup[@content-desc="For Rent"]
${L_FILTER_TABS_SOLD}    xpath=//android.view.ViewGroup[@resource-id="x:id/segment_selector"]//android.view.ViewGroup[@content-desc="Sold"]
${L_FILTER_TABS_LEASE}    xpath=//android.view.ViewGroup[@resource-id="x:id/segment_selector"]//android.widget.TextView[@text="For Lease"]
${L_FILTER_RANGE_MAX_DROPDOWN}    id=x:id/filters.range.max_dropdown
${L_FILTER_RANGE_MAX_DROPDOWN_SCROLLVIEW}    xpath=//android.view.ViewGroup[@resource-id="x:id/filters.range.max_dropdown"]//android.widget.ScrollView[@resource-id="x:id/dropdown.scrollview"]
${L_FILTER_RANGE_MAX_DROPDOWN_ITEM}    xpath=//android.view.ViewGroup[@resource-id="x:id/filters.range.max_dropdown"]//android.widget.TextView[@text="{PRICE}"]
${L_FILTER_RANGE_MIN_DROPDOWN}    id=x:id/filters.range.min_dropdown
${L_FILTER_RANGE_MIN_DROPDOWN_SCROLLVIEW}    xpath=//android.view.ViewGroup[@resource-id="x:id/filters.range.min_dropdown"]//android.widget.ScrollView[@resource-id="x:id/dropdown.scrollview"]
${L_FILTER_RANGE_MIN_DROPDOWN_ITEM}    xpath=//android.view.ViewGroup[@resource-id="x:id/filters.range.min_dropdown"]//android.widget.TextView[@content-desc="{PRICE}"]

${L_FILTER_STEP_BEDROOMS_MINUS_BUTTON}    xpath=//android.widget.Button[@content-desc="Decrease bedroom count"]
${L_FILTER_STEP_BEDROOMS_PLUS_BUTTON}    xpath=//android.widget.Button[@content-desc="Increase bedroom count"]
${L_FILTER_STEP_BEDROOMS_TEXT}    xpath=//android.widget.Button[@content-desc="Decrease bedroom count"]/following-sibling::android.widget.TextView[1]

${L_FILTER_ACCORDION_HEAD_PROPERTY_TYPE}    id=x:id/accordian.property_type.header
${L_FILTER_ACCORDION_BODY_PROPERTY_TYPE}    id=x:id/accordian.property_type.body
${L_FILTER_ACCORDION_ITEM}    xpath=//android.view.ViewGroup[@resource-id="x:id/accordian.property_type.body"]//android.widget.TextView[@text="{TEXT}"]

# Property Info
${L_PINFO_SCROLLVIEW}    id=x:id/page.property_details
${L_PINFO_MLS_CODE}    id=x:id/page.property_details.summary.mls_number
${L_PINFO_NAME}    id=x:id/page.property_details.summary.address
${L_PINFO_PRICE}    id=x:id/page.property_details.summary.sale_price
${L_PINFO_BEDROOMS}    id=x:id/page.property_details.summary.bedrooms.value
${L_PINFO_BATHROOMS}    id=x:id/page.property_details.summary.bathrooms.value
${L_PINFO_SQUARE_FOOTAGE}    id=x:id/page.property_details.summary.squareFootage.value
${L_PINFO_PROPERTY_TYPE}    id=x:id/page.property_details.summary.property_type.value
${L_PINFO_GET_DIRECTIONS_BUTTON}    xpath=//android.view.ViewGroup[@resource-id="x:id/page.property_details.summary"]/android.widget.Button[1]/android.view.ViewGroup
${L_PINFO_VIEW_MAP_BUTTON}    xpath=//android.view.ViewGroup[@resource-id="x:id/page.property_details.summary"]/android.widget.Button[2]/android.view.ViewGroup

${L_PINFO_REALTOR_HEADER}    id=x:id/page.property_details.realtor_information.header
${L_PINFO_REALTOR_NAME}    xpath=//android.view.ViewGroup[@resource-id="x:id/view.realtor_information.card"]//android.view.ViewGroup[@resource-id="x:id/topContainer"]/android.view.ViewGroup[2]//android.widget.TextView[@text]
