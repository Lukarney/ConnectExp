# ConnectExp
## Table of Contents
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)
5. [Data Models](#Data-Models)
6. [Ambiguous Problem](#Ambiguous-Problem)
7. [Milestone Layout](#Milestones)

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
* User can request to connect
* user can create an account
* user can login
* users can be on the feed


**Optional Nice-to-have Stories**

* user can tap on photos for a detailed view
* user can view profile
* user can message
* User can match with another user

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
* Settings/define search
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



User
| Property   | Type           | Description |
| --------   | --------       | -------- |
| ObjectID   | String.        | unique ID for the user | 
| Author.    | Pointer to user     | To hold the data of the user     |
| image.     | File.          |  image the author puts on the post
| Description| String         |  text the author puts on his post
| Created at | DateTime       |  date for when the post is created
| Location.  | LatLong            |  Location for knowing proximity of services |
| MessageThreads    | array of MessageThreads |  To hold the data of the user's message threads |

Message
| Property   | Type              | Description |
| --------   | --------          | -------- |
| ObjectID   | String.           | unique ID for the Message 
| Sender.    | Pointer to user   | To hold the data of the sender     |
| Reciever.    | Pointer to user | To hold the data of the Reciever     |
| image.     | File.             |  image the author puts on the post
| Text       | String            |  text the author puts on his post
| Created at | DateTime          |  date for when the post is created |

MessageThread
| Property   | Type                      | Description |
| --------   | --------                  | -------- |
| ObjectID   | String.                   | unique ID for the MessageThread | 
| Users      | Array of pointers to user | To hold the data of users |
| Messages   | Array of Messages         |  To hold the data the messages|


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
    

## Ambiguous Problem

_*Ambiguous issue: How can I get two people with similar interest and based on proximity to connect.*_
GIVEN: 

* A List of user’s Profile :
* interest(ID e.g. “1”)
    * ID links to interest. e.g. 1 represents cooking
* what they want(string “Partner”)
    * List of options will be given to the user e.g.
        * “Partner”
        * “Master”
        * “Noob”
        * “Exchange”
*  [optional] description of what the user is willing to give(string e.g “I want to learn more about hiking and am willing to give...”)
* location
* proximity parameter (Integer e.g. 50 miles)

OUTPUT: List of compatible users based on priority of. Dictionary where key is UserID and each value is a possible user 

Part 1: What defines a good match? 
→ The proximity weighed heavily 
→ What the user wants compared to what they ask for 
→ Add weight of what defines a good match
→ Sorting and comparison
Part 2: What constraints do I have
→ Number of users
→ Locations will be between certain points
→ Interest 
Part 3: How good do I want my solution to be
→ What makes a good score
→ Should I make it Optimal vs. accurate, 
→ 

## Milestones

*Milestones Layout:*
Week 4:

    * Login & Logout
        * User should be able to login into the program and the user should be exit back to the login screen and not be
    *Skeleton
        * Should have a basic outline for what models, controllers, and view I want while also having TODO functions to implement
  

Week 5:
    
    * Swiping motion
        * User should be able to. swipe a card
    * Viewing feed
        * User should be able to view multiple people on their “feed” and swipe through them
    * Creating Account
        * User should be able to create an account and use said account to log into the app

Week 6:

    * Matching with User
        * Users should be able to match with a user that notifies the other user of their request
    * Algorithm
        * Algorithm that allows one user to find a compatible user to then request to meet up

Week 7:

    * Overflow time if work does not get finished in time
    * [optional]Messaging
        * allow the users to message one another 


Week 8:

    * Overflow time if work does not get finished in time
    * [optional]Search
        * Allows the user to search through matches
    * Finalize UI 
        * Touch up UI to ensure that it is cohesive and presentable 


   


