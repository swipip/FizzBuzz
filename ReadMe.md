
# FizzBuzz App

****test coverage: ~80%****

## Global feedback

First I would say it was quite a fun and challenging test to do. At first it seemed really simple yet I decided to take it a step further and give the app a purpose. While complying with the test requirements I added a 'gaming' experience into the mix. Therefore, rather than just featuring a straight forward 'form app' it has a bit more meaning. And it helped also during the development having a goal.

## Implementation comments

### UI

The UI is fairly simple. I took a flat design approach. There are three main screens:

- ****A form screen****: This screen is composed a one collectionView only and is embedded into a navigation controller. For the form part I took the risk to move away from the traditional list form for two reasons:

- From a UX point of view, the user is focused on the field on screen and it gives plenty of room for handling errors as well as give user hint about what he is supposed to achieve

- I also saved quite a bit of work making sure every field in a list was accessible on small form factor devices.

I choose to embed the viewController into a navigationController in prevision for future development i.e new screens of new features.

- ****A Stats screen****: This screen is responsible for displaying the user statistics about his previous games. So it's a collectionView displaying a list of most played games with stats showing the number of games. The user can replay each games by tapping the cell. I choose not to go down the road of building a graph because I wanted to keep the code simple and easy to understand (as per requested) ans because I thought in the context of a game I was making more sense from a UX stand point.

- ****A game screen****: This screen where the user plays really. It is extremely simple you tap the left button when the displayed number is a multiple of 'int1', the second button when its a multiple of 'int2' and the screen when it's a multiple of both. There is a score field where the score increments. The controller auto-dismisses upon game-end.

*****_The output string from the form is displayed at the end a each game_*****

The first two controllers are embedded into a tab-bar controller and the latter is modal. The bar bar controller features some bespoke behavior such a a selection indictor, images, border and a custom transition animation when navigation between the two controllers.

I used xibs for views as I find the interface builder quite efficient for interacted views. I don't mind programmatic but I feel it clutters the code more than anything (with a framework it gets easier and saves you the trouble from instantiating views with nibs.).

  

### Architecture

The navigation flow is handled through coordinators. I think it is quite 'overkill' for such a small app but iI anticipated potential new features (production ready). That way the app is more scalable.

  

- It makes the app easier to test. Especially as it grows and if we need to implement UI test. (Allows to skip screen for instance)

- It is easier to A/B test. We can quickly switch flows and/or add/remove screens

- Easier to handle deep-linking

  

In the context of the app it makes the controller agnostic of each others and allows navigation from anywhere in the application.

  

Screens are designed following MVVM. Delegation is the norm. I used no reactive programming though in some cases I could have used combine.

  

### Data

The data model is quite simple. It is made of two main structs:

  

- ****Form****: It is the model that get passed between controllers, saved and retrieved from memory. It feeds the game engine and the stats controller.

- ****FormIntstruction****: It is the data model which is passed into FormCells under FormController. It provides useful information for the cell, namely the type of keyboard to use, titles, description. It is meant to be extended as the form grows in complexity. It performs some basic data validation.

  

Data persistence is achieved with UserDefaults. I choose userDefaults because it is easy to use and to stub out when testing. CoreData would have been too much for this simple project yet to consider when scaling.

I created a layer called *****_FormsService_***** responsible for saving and fetching the data. I made all the tasks async so that if we later need to switch to a remote service we would just need to plug a networking service and the rest would continue to work. (Additionally I assigned the fetching and decoding of existing data to a background thread in order to secure performance)

  

### Testing

  

I followed a TDD development process and most features are tested. We are close to a 80% coverage rate.

  

## What I would do next

  

Of course there is plenty of room for improvement

### UX

I would take further the game experience. In the output string highlight errors, improve the points counting system, display encouragement messages and so on...

### Data

If the goal was to make the app 100% offline I would have implemented a local storage solution such as CoreData or Realm

### Error handling

Error handling is at its bare minimum. Currently the app is quite stable and very few exceptions can occur yet I would still implement retries and visual feedback to the user.

### Testing

I would implement UI Tests as application grows in complexity
