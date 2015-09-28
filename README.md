### Yelp client

Basic Yelp client implementation with list view, map view and search

Time spent > 30 hours

### Completed features

I took a stab at all the optional features except restaurant detail view

- Search results page
    - Table rows should change height according to the content height (Required)
        - Issue: Deals label adds additional space at the bottom of the cell even though its hidden. Setting the constraint constant for deal text to 0 didnt help. Removing and adding contraint programmatically in code was resulting in a crash
    - Custom cells should have the proper Auto Layout constraints (Required)
    - Search bar is shown in the navigation bar (Required)
    - Infinite scroll for restaurant results (Optional)
        - I tried using scrollViewDidScroll() and table view's didEndDisplayingCell() function to trigger Yelp call when reaching end of the table view, but couldnt identify the magic incantation that tells me that user has scrolled to the end of the table list
        - Added Browse More button at the end of the list that shows more results
    - Implement map view of restaurant results (Optional)
        - Search and filters work in map mode like expected
        - Issue: Even though I am using core location and mapview is set to show user location, I am not seeing a blue dot. This used to work, but after a refactor to move all the core features to SearchViewController, this is broken.

- Filter Page
    - Implemented category, sort, radius, and deals filters (Required)
    - Filters table is organized into sections (Required)
    - Clicking on the "Search" button dismisses the filters page and trigger the search w/ the new filter settings (Required)
    - Implemented custom switches and custom drop down menu for Single Select and Toggle switches (Optional)
    - Radius filter expands as in the real Yelp app (Optional)
        - This requirement is vague to me. I added additional radius filter to pass to the OAuth call and verified that increasing distance in filter increases the location spread of businesses returned
    - Categories show a subset of the full list with a "See All" row to expand (Optional)

### Walkthrough:

![alt tag](https://github.com/udaymitra/Yelp/blob/master/walkthrough.gif)
