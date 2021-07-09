# MOVIE APP

### In the app:

*MVVM design pattern is used.  

*TMDB API is used for datas.

*URLSession is used for network requests.

*Userdefaults is used about store favorite movie ids. 

*Any 3rd party libraries does not used.


### Overview:

**Movie List Screen**

The app has two screens as a movie list and a movie detail screen. 

First screen contains a search bar, a popular movies list and a load more button. 

When user types more than 2 character in search bar, it works for fetched movies.
 
In each element of the movie list, there are movie name, poster and whether favorite movie or not.

When user clicks the load more button, movies is fetched page by page.

When user clicks one of the movies, movie detail screen opens.

**Movie Detail Screen**

In detail screen contains movie poster, name, description, vote count, star button and back button. 

When user clicks the back button, he/she back to movie list screen.

When user clicks the star button,  movie is added to (or removed from) the favorite list. Favorite list is stored on device.
