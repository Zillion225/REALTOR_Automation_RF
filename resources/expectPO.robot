*** Variables ***
# Permission Pop Up
${T_PERMISSION_DEVICE_LOCATION_POPUP}   Allow REALTOR.ca to access this device’s location?

# Search Screen (Home Screen)
${T_TITLE_MESSAGE_WELCOME}    Welcome to REALTOR.ca®
${T_TITLE_MESSAGE}    Showing listings near you

# MAP Area
${T_TITLE_MAP_AREA}    Show Map

# Search Bar
${T_SEARCH_BAR_PLACEHOLDER}    Location or MLS®#

# Filter
${T_FILTER_PAGE_TITLE}    What are you searching for?
${T_MAX_RANGE_MAX_PRICE}    20,000,000
@{FILTER_STEP_BEDROOMS}    Any    1    1+    2    2+    3    3+    4    4+    5    5+
@{FILTER_STEP_BATHROOMS}    Any    1    1+    2    2+    3    3+    4    4+    5    5+