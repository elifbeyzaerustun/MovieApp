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

![MovieListScreen](https://user-images.githubusercontent.com/52157128/125044146-5b8a9800-e0a4-11eb-80c3-0f232eafdbc8.png)

![MovieSearchScreen1](https://user-images.githubusercontent.com/52157128/125044559-be7c2f00-e0a4-11eb-8e56-b4a0d254ceae.png)

![MovieSearchScreen2](https://user-images.githubusercontent.com/52157128/125044571-c1771f80-e0a4-11eb-99a1-6e399a5d0530.png)

**Movie Detail Screen**

In detail screen contains movie poster, name, description, vote count, star button and back button. 

When user clicks the back button, he/she back to movie list screen.

When user clicks the star button,  movie is added to (or removed from) the favorite list. Favorite list is stored on device.

![MovieDetailScreen](https://user-images.githubusercontent.com/52157128/125044282-7d841a80-e0a4-11eb-9fb4-4f4af9250a98.png)
