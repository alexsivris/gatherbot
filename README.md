# mIRC Gatherbot for CS 1.6 #

This mIRC script can be used to create simple pickup-games (5vs5) in an IRC channel where privileged users (called *admins*) can start games and normal users can add themselves to these games. The idea was inspired by the Greek gather networks that were very popular at around 2006-2008 (channels `#cs-gather`, `#5vs5`, `#hl-gather`, etc. on the GRNet IRC server) and also used similar systems to organize games. 
This script was developed in early 2008.

## Usage ##

### Admin commands ###

Admin is considered everyone that has operator access rights in the gather channel.

#### In channel: ####

**!move** *nickname*: move a user to the other team
**!del** *nickname*: remove a user from the game

#### private message to gatherbot: ####

**!startgame** *server_ip* *password*: starts a game on the server specified by the IP address *server_ip* and the password *password*<br />
**!type** *description_of_game*: set the description of game (e.g. the rule set, like "max rounds 15 - 5 vs 5 - Anti-cheat ON").
**!map** *map name*: set the map of the game (e.g. "de_dust2")
**!info ok**: confirm that everything is set correctly and start the game
**!setmenext**: set the admin next in the queue
**!delme**: removes the admin from the queue
**!mygames**:  shows total number of managed games
**!stats** *nickname*: shows stats of nickname
**!clearstats**: sets all the games of every admin to zero (only head admin can execute this command. The head admin is specified in the aliases list of mIRC as %headadmin).

### User commands ###

Of course the admin can also execute the user commands.

#### In channel: ####

**!next**: show which admin is next in the queue to start a game (if there is any)
**!teams**: show current team set up
**!mystats**: user stats (total games) are notified to the user
**!totalgames**: total games the gather channel has launched in a month
**!add** *a/b*: adds user to either team a (usually CT) or team b (usually T). In case the user just types **!add**, the team is chosen randomly and/or according to current team count
**!getpass**: when the teams are full and the password hasn't been sent yet, the user can request the password with this command



