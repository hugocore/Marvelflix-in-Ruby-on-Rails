# Marvelflix

### Challenge spec:

![Marvelflix](/assets/page.png)

- Description:
    - Using the best API available on this side of the universe, https://developer.marvel.com/ , make a simple app that allows the user to scroll trough all the comics ever released from the most recent to the oldest (and please, let me see the cover picture while I do it!);
    - Make it easy to search amongs the comics;
    - Let me upvote my favorite comics.

- Functional requirements (Using the Job to be Done framework):
    - When I open the page I want to see a list of all Marvel’s released comic books covers ordered from most recent to the oldest so I can scroll trough the the Marvel universe;
    - When I see the list of comics I want to be able to search by character (ex. deadpool) so that I can find my favorite comics;
    - When I see the list of comics I want to be able to upvote any of them so that the most popular are easy to find in the future.
    
### Solution

In my approach, I've used a simple **Rails 5** application backed by a *SQLite* persistent database and a cache database using **Redis**. The front-end  together with **React** and **Redux** to accomplish this simple application. Nevertheless, there were a few details that required a few complex approaches, for instance:

#### Feature 1: I open the page I want to see a list of all Marvel’s released comic books covers ordered from most recent to the oldest so I can scroll trough the the Marvel universe;

-	This feature was the base of the project, because it defined the structured of models, controllers and views. To address it I applied the [Clean Code Architecture](https://medium.com/streetbees-engineering/pragmatic-clean-code-architecture-d0d34f38849a#.dhafo5ilx) that divides each feature in [use cases](https://github.com/hugoseq/Test/tree/master/app/use_cases).
-	Because this feature required a connection to Marvel’s API, and since this latter as a daily maximum threshold of 3000 requests, it was required to build a cache that saves the response of each request, and its context, for 24 hours (recommended by [Marvel](http://developer.marvel.com/documentation/attribution)). Thus, if a user requests the comics of Deadpool, and if no one else as requested that before, a request is made to Marvel’s API and its response is [cached](https://github.com/hugoseq/Test/blob/master/app/use_cases/comics/index/fetch_comics.rb). For the following 24 hours, everyone querying for the same comics will obtain the same cached response.

#### [Feature 2]( https://github.com/hugoseq/Test/issues/3): When I see the list of comics I want to be able to upvote any of them so that the most popular are easy to find in the future.

-	It was necessary to save each User’s up votes in our persistent database and map each Comic returned by the cache or by Marvel’s API directly, with the up votes of the current logged user. To avoid a **N+1 problem**, where we would iterate each comic and query the database for its up votes, I’ve [preloaded all]( https://github.com/hugoseq/Test/blob/master/app/use_cases/comics/index/fetch_user_upvotes.rb) the up votes of the current user for the comics obtained. This way, in the end of the use case, all we have to do is a simple memory search and map a Comic with a Upvote.
-	Comics are not saved in the persistent database. That’s because we are caching them in our caching database, and after a certain time they seize to exist because they become invalid. Another reason is that they are thousands of comics in Marvel’s database. Dumping all those comics into our database would take time and be pointless, based on the requirements. Therefore, each [Comic is an OpenStruct]( https://github.com/hugoseq/Test/blob/master/app/models/comic.rb) that has an Upvote associated. If the Upvote exists, then the comic was previoulsly upvoted by the User. This class also performs some actions that are going to be handy later on to render each comic.

#### [Feature 3](https://github.com/hugoseq/Test/issues/4): When I see the list of comics I want to be able to search by character (ex. deadpool) so that I can find my favorite comics.

-	This requirement required that we could find a certain character, obtain its ID and then pass along that variable to our Comic use case, to filter its comics list based on this ID.
-	Searching the character required that we had to do a substring operation to select a character based on a set of characters. For instance, searching by “captain” had to return all the characters named after this. Since Marvel’s API didn’t offer this out-of-the-box, I had to cache/dump their characters (around 1400) into our persistent database, so I can then search by a string. To achieve this, I’ve built a [rake task]( https://github.com/hugoseq/Test/blob/master/lib/tasks/marvel.rake) that downloads 100 characters at the time into our database. This task, in production, should be called daily using some cron job. This wont affect our threshold, because it’s only 14 requests in total that run quite fast. It’s also wrapped in a transaction, so once it completes, it updates the database instantly. You can run this task with ` rake marvel:cache:characters`

#### Front-end

This is the part that lack the most work. Right now, the foundations to accomplish a single-page application using React and Redux are in place. The basic idea is to have [Redux async actions]( https://github.com/hugoseq/Test/blob/react/client/app/bundles/HelloWorld/startup/ComicListClient.jsx), using Redux-Thunk, querying Rails’ endpoints and fetch comics and characters, and React components to subscribe to those state properties and update their UI.

Ideally, there would be these components:
-	ComicWidget: a simple comic instance with the comic thumbnail and buttons to upvote
-	ComicList: a component to hold all the ComicWidgets and to interact with Redux/API
-	SearcComic: a component to search for characters, choose one and to pass that character Id back to the ComicList to search/filter comics
-	ComicContainer: a component that would hold a ComicList and a InfitineScroll container to provide an infinite scroll effect

#### TODO

-	Test use cases and controllers (check the `coverage/index.html`)
-	Finish the front-end
-	Design the style sheets (Sass)
-	Docker’up
-	Deploy
