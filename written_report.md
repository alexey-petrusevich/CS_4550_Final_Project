# Written Report

## The Team

Our team consists of Alexey Petrusevich, Benjamin Ockert, Austin Kim, and Iain Morrison.

## The Deployment

Our deployed app can be found at http://spotifyparty.quickjohnny.art/, and our source code can be found at: https://github.com/alexey-petrusevich/CS_4550_Final_Project. Our app
is currently deployed and working as it should. The individual work that each member has done on the project is as follows:

### Alexey Petrusevich

My primary responsibility for the project was backend functionality. That is, adding event handlers capable of receiving GET, POST, and PUT requests. Along the way my teammates and I agreed upon schemas for various resources: Auth (authorization), Parties, Requests, Songs, Users, and Votes, as well as accessing these resources, storing it in the database, updating router, and other necessary functionality.

In addition to that I was responsible for making Spotify API requests to accommodate functionality of our app. In most of our requests we use a token with a set of predefined scopes each required for different API calls. For example, playlist-read-collaborative and playlist-read-private for getting a collection of users playlists. On the other hand other calls would not require any scope, and thus we could use a scopeless token.

As part of our project, we collect information about the songs being played during each party. Information such as danceability, valance, loudness, and other is accessible by requesting song audio features. A complete documentation on Spotify API can be found here: https://developer.spotify.com/documentation/web-api/reference/

### Benjamin Ockert

My first task was to implement the user authorization flow when a user starts a new party. I registered our app with Spotify for Developers and configured the redirect uri to point to one of our server’s endpoints. That way, when a user clicks the ‘Link with Spotify’ button, after they input their credentials and approve our requested scopes (reading user’s private playlists, and reading/modifying their current playback), the authorization code is sent to our server which then securely handles exchanging the authorization code for a user access token. I then built out the main user components of our app, including the landing page and party page. For the party page, I had to handle displays and flow for 6 possible states: party not-started, party active, and party ended. Also on the party page was the loading of the host’s playlists once their account has been authenticated. I used sockets to pull the data in real time and display their choices in a bootstrap dropdown. Once they select a playlist and hit ‘Start’, their songs are instantly loaded to their page as well as the pages of all participants, which I again used channels for. To finish up the flow for parties, I implemented real time ong requests and voting. Finally, I made significant improvements to the overall styling of our app, including styling the landing page and song cards, and adding a bootstrap Jumbotron to each party page.

### Austin Kim

During our planning phase, I was involved in planning out the structure of the database, as well as providing lofi mockups of how our UI could be designed and structured. Apart from that, the 2 main sections I worked on were all the User pages and the User Stats module. For the User Stats Module, I used the Rechart.js library to make 3 different graphs to display a User’s top artists, top genres, and style preferences, based on the songs belonging to the parties the user has attended, or hosted, which was taken from a SQL query I wrote in the backend. This data would be presented differently based on whether it was loaded on the Dashboard, or on a user’s Profile page. While the graphs displaying these data sets are interesting to look at, the user’s impact score was the more personal touch to our app that added personality and goals to every user. I created 5 ranks that a User could achieve, starting from Noob, and ending with Elite, where progression and score would increase based on parties hosted, requests made, and votes made. I also worked on adding a grid layout to the dashboard and profile pages, so that all the information would be presented to the user at the same time; I used the React Grid Layout library for these layouts. While these were the sections I mainly worked on, throughout the weeks I also provided input on backend flows, helped find proper Spotify API endpoints, styled various components, and provided seed data.

### Iain Morrison

I was involved in the brainstorming and planning for the formatting of our code for the project in the beginning stages of development. This includes what resources our back-end should support, and what items like Users, Parties, etc. should be able to do. My first task for the project was to help develop the socket and endpoint functionality to allow for multiple users to attend the same party concurrently. I also worked on the initial deployment and testing of our site in a browser rather than through localhost. Using this, I was involved in future deployment and testing of functionality, including the deployment of our app to multiple sites. Another thing I worked on is ensuring that all files that required pointing to a URL of either me or a team members site worked as they should when deployed. The above was my main focus for this project, but I also assisted the other members in the writing of our proposal and report, as well as the production of our presentation.

## The App

Our app is called Spotify Party. When public health protocols allow, our app will allow people to DJ their own parties with input from all of their friends. After registering for an account with our app, users will be able to either host a party or join a party using a code given to them by the host. 

When the host starts a party, they will be able to see their 10 most recent Spotify playlists and choose which one will be the playlist for their party. Attendees at the party will be able to provide their opinion on each song through voting. If they don’t see a song they like, they can make a request by providing the song’s title and artist. The host “DJ” will be able to see all votes and requests and make a decision about what songs to add to the queue next. 

Our app then takes user’s data, like user’s request and voting habits, as well as the information about what songs were played at each party they attended, and displays neat graphs. Our app also keeps track of each user’s “impact score”, which is increased by 1 when a user votes for or requests a song, another 1 if that song makes it to the party queue, or 20 points for the user who acts as host. Users can see the impact score and listening statistics of all other users on our app, and can compete with each other until they reach ‘Elite’ status with an impact score of 500, after going through the Noob, Silver, Gold, and Platinum levels, of course.  

## Changes Since Our Proposal

Since our initial proposal, our app has changed in several ways. First, we added a landing page as well as a users list page. Instead of just having a dashboard page with party history and user statistics, the landing page acts as “quick access” for starting a party or joining a party, which are the two primary actions we expect our users to take when accessing our site. The users list page then was added to allow friends to see what other users are listening to, and have a friendly competition, as was mentioned above. This gives meaning to the “impact score”, which is another feature we added since our proposal. 

Other changes we made was to our initial database design. Our schema for parties now includes an “active” flag for determining the status of a party. Our songs schema now includes more detailed song information such as danceability, loudness, and valence (happiness). It also includes a genre. Our users schema now includes an impact_score as well as top artists and top genres. And lastly, we added a new access token table for securely storing user access tokens while they are valid. 

## Realtime Behavior

First of all, when anyone joins a party room, all other users in that room are notified of a new guest. But the main realtime features are the following:

While using the app, users are able to interact with the "DJ" in real time through voting and requesting songs. As soon as the party starts, users will be able to see all songs from the host’s chosen playlist. Each song will have a vote-up and vote-down button, which updates in realtime across the host and all attendees. Based on the results of voting at any given time, a host can select a song and add it to their playback queue. The host and attendees will be notified when a song is added to the queue, serving as a success message for the host action, but also as an informative message for the users who want to see if their song was accepted. Similarly to voting, a user can specify a song title and artist in the request form, and, if a matching song is found on Spotify, the song immediately populates in the host’s view. 

Other realtime behavior is the pulling of user playlist data immediately after authenticating their account, followed by immediate population of songs to all attendees’ view when the party starts. Lastly, when a party is ended by the host, the view of the host and all attendees gets updated in real time as well. The view now displays what songs and requests were played, rather than what songs can be added to the queue. 

## Persistent State

Our app stores user specific data and party specific data.

For users, we store their basic account credentials (using Argon2 for securely hashing passwords) as well as their listening trends and what votes/request they make over time, which leads to their impact score. We use this data to display reactive graphs in multiple forms, such as top artists, top songs, and average song attributes like danceability and happiness.

For parties, we keep track of what songs were on the initial playlist as well as what songs made it to the queue. We also store the device id that was used for playback. This allows us to handle future playback of the host’s parties more quickly. Finally, we store an association of users with each party so we know who attended what party and who was host. This allows us to configure the user dashboard page so attendees of a party session will be able to look back on their past events and see what songs were played, in what order they were played, and how
many votes each song had. This will be useful to all users if and when they want to make a playlist for their own hosted party.

## External Spotify API Usage for Playback and User/Song Data

At any point the "DJ", or host, can play, pause, or skip the currently playing song utilizing buttons on their view of the party. When a song is skipped, the next song in the queue is played. These actions are performed through a client-to-server and server-to-API flow. When a host interacts with the playback buttons, a packet is sent through the party’s channel to the server, which is where the call is made to Spotify’s Playback endpoints. 

For requests, we use Spotify’s search endpoint with the track and artist tags. We return the top search result and create a song entry with the song’s basic information. We store the same basic information when pulling the initial songs from the user’s selected playlist. Then, when a song is added to the queue, we use Spotify’s artist endpoint for getting the genres associated with the song as well as their audio features endpoint for getting the song’s meta data for our graphing features. 

## Complex Feature [“Something Neat”]

On any given user's "User Page" we provide a variety of user statistics. These statistics are generated based on how the user voted for songs that get added to the queue during parties. These statistics come from the songs' data on Spotify, and are pulled using the Spotify API and visualized by our app. The statistics being shown are top artists, top genres, as well as audio features that Spotify keeps track of, including "danceability", "valence", "energy", and "loudness".

This visualization is done through the use of the Rechart.js library. This library provides a variety of different graphs using data that our app takes from a SQL query. The visualization of these kinds of statistics gives users of our app a view of what their overall tastes have been in parties that they have attended in the past, and the data could help them make a Spotify playlist of their own if they so wish.

Another complex feature that we implemented is an “impact score” that is visible on each user’s User Page. This impact score increases based on how much impact the user has had on song choice in parties in the past. This includes having songs that they requested play at the party, as well as songs that they up-voted in the voting round. Additionally, a user would get a certain amount of impact score points for hosting a party. This impact score is correlated with a rank that a user receives, also shown on the User Page. As mentioned above in Austin’s section, these ranks can range from the lowest rank, Noob, all the way to the highest rank, Elite. There are 5 ranks in total that a user can achieve, and once a user becomes Elite they can still accrue impact score but they will not rank up any further.

### Significant Challenge

A challenge we faced was with graphing all of the data we were receiving from Spotify about the songs that were played during parties. Because the metrics we were receiving had different units of measurements (i.e. beats per minute, decibels, etc.), we had to scale the data in a way that was readable and meaningful to the user. Also, we found that Spotify has over 1000 genres of music and associates a single song and artist to several genres, so we had to group genres into more refined categories by keyword in order to display a more limited and understandable metric to the users. 

Another challenging part of development was debugging our deployed app. We managed to get the base app deployed fairly readily. However, we had to work out all the communication between our app, our channel, our own API, and Spotify’s API (for both authentication and normal requests), and ensure that the information we receive is accurate and timely. Because sessions are stored locally in the browser, it was sometimes difficult to be logged in as two separate users and test real time updates. We overcame this during development by opening tabs in both Firefox and Chrome, but that wasn’t ideal, so a further emphasis was placed on deploying regularly so we can test in production. We ultimately were successful in deploying our app as a single page application, and are happy with the features we have implemented. 
