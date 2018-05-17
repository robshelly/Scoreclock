# Ice/Inline Hockey Style Scoreboard iOS App

This is an iOS app that implements a scoreclock for inline/ice hockey, implemented in the style of a score board. This project was completed as an assignment for Mac Programming.

## Use Cases

The app was developed with two main use cases in mind:

* Provided a simple method of scoring and time keeping games in small recreational leagues/tournaments which lack proper system or number of officials to implemented full statistics
* Provided a simple and free method of sharing/publishing scores to the Internet for recreational leagues which lack publicity or publication for game score and results.

## Features

The app has been styles to replicate a typical ice hockey scoreboard, which displays information about the time, periods, goals and penalties. 

* Game clock: tracks the time of the current period. Can be set to custom time to accommodate different length games.
* Current Period: Indicates the current period. Can be 1st, 2nd, 3rd or overtime.
* Home and Away Goals: i.e. the current score.
* Current penalties: Can track up to two current penalties for each team.

### Post Goal Statistics to Social Media

Also implemented is the ability to share goals to social media via the inbuilt share function of iOS. This allows the users to post goal statistics as goals are scored to media such as twitter. This feature is of course optional.

Goal statistics record the team, time and period of the goals. The scoring player along with any assists can also be record. Below is a sample statistics as would be shared to social media:

    Goal!
    Home team @ 13.53 (1st)
    Stamkos
    Assists: Hedman, Point

## Future Development
The project includes a number of stretch goals.

### Expand Penalties Functionality
The scoreboard shows any current penalties being being served by either team (two per team as standard). However, some scoreboards will also indicate the jersey number of the player currently serving the penalty. This feature should be added in future development.

The statistics sharing feature should also be expanded to included penalties. I.e. the users could share to social media details about penalties awards such as the offending player, the infraction and number of penalty minutes awarded.

### End of Period/Game
Future development should also expand the statistics sharing feature to allow users to share the current score at the end of periods, and the final score.

## Dependencies

**AVFoundation:** Used to implement sound bites for goals horn and end-of-period buzzer. (Sounds can be turned off in the app)
