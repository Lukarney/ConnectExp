# ConnectExp
## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Connects people that are experts or want to share their time with others that want to gain experience in that field. For example, a music producer or tennis coach willing to give time to train others. Experts teach eachother. friend matching app. 

### Ambiguous or difficult challenge
Problems:
Matching algo: How to evaluate data points.
Authentic data about people. How to know if the algo is good.
Use mock data to evaluate people. Use distance to help define more people.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:**
- **Mobile:**
    -This product experience is uniquely mobile as this app similar to marketplace, etsy, and other shopping apps can be perfected on app.
    -Allows users to search, match, and integrate their brand and their wants into one place.
    -realtime, location, camera
- **Story:**
    - There is a story around the app as it can connect professionals to local people faster
    - The value is clear: it is an exchange of services to help one person get better at a task for money.
    - Friends and peers would not respond to this prod
- **Market:**
    - On the assumption that this app would compete against apps like udemy, masterclass, and other learning apps, we can expect that it is a large market but not unique.
    - Relatively large as it is not niche users and there's always someone willing to learn.
    - does provide value
- **Habit:**
    - I don't think a user would use this daily
    - Not addictive, but could be habit-forming as it could lead users to want this app to learn new topics
- **Scope:**
    - The scope is not well-formed
    - App matches people so I do not think it would be that challenging
    - It is not currently clearly defined

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can view feed
* User can match with someone
* user can create an account
* user can login
* users can be on the feed

**Optional Nice-to-have Stories**

* user can tap on photos for a detailed view
* user can view profile
* user can see reviews
* user can see who similar people
* user can find people based on location specs
* user can find people based on requirements
* user can message

### 2. Screen Archetypes

* Login screen
   * user can login
* Stream
   * user can fiew feed
   * User can request services from someone
   * user can view profile
* Creation
    * User can post their services to their feed
* Search
    * user can find people based on requirements
* Details
    * User can request services from someone

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home feed
* Search/ define users
* Post 

**Flow Navigation** (Screen to Screen)

* Login Screen
   * Home
* Registration Screen
    * Home
* Stream Screen
    * profiles
* Creation Screen
    * Home
    * stream
* Search
    * None
* Profile
    * Stream
    * Setting

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.imgur.com/6PY4IkY.png" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]


## Data Models



| Property   | Type           | Description |
| --------   | --------       | -------- |
| ObjectID   | String.        | unique ID for the post 
| Author.    | Pointer to user     | To hold the data of the user     |
| image.     | File.          |  image the author puts on the post
| Description| String         |  text the author puts on his post
| Created at | DateTime       |  date for when the post is created
| Location.  | ??             |  Location for knowing proximity of services
| Requested  | array of users |  To identify what users responded to post
|

## Parse Network Request

Home Feed Screen
    -(GET) Query all post based on algo
    -(POST) Create a request to talk to someone

Create
    -(POST) Create new post object

Profile
    - (GET) Query user object
    -(update?/PUT) update user info

Message
    -(POST) Create new message
    -(GET) Query messages
