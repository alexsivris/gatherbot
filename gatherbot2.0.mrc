on 1:load:{ .settings | echo -a Settings Loaded successfully ! }
alias start_game {
  set %add allowed
  set %getpass notallowed
  set %team.a ? ? ? ? ?
  set %team.b ? ? ? ? ?
  set %alpha.slots 0
  set %beta.slots 0
  set %totalplayers 0
  set %gamemap Not given !
  set %gametype Not given !
  msg %main :[]: A game has started on %main ! :[]:
  mode %main +Mm
  topic %main 1:[]: Go subscribe ! .:. Type: %gametype .:. Current Map: %gamemap .:. Your admin is $nick ! :[]:
  msg %main :[]: We wish you Good Luck and Have Fun !!! :[]:
  .msgteams
}

alias settings {
  set %team.a ? ? ? ? ?
  set %team.b ? ? ? ? ?
  set %queue ? ? ? ? ? ? ? ?
  set %alpha.slots 0
  set %beta.slots 0
  set %totalslots 0 
}

on *:text:!add*a:%main:{
  if (%add == allowed) {
    check_user_a
  }
}

on *:text:!add*b:%main:{
  if (%add == allowed) {
    check_user_b
  }
}

on *:text:!add*:%main:{
  if (%add == allowed) {
    check_user_random
  }
}

on *:text:!move *:%main:{
  if ((%add == allowed) && ($nick == %gameadmin)) {
    check_admin_move
  }
}

alias check_admin_move {
  if (($2 isincs %team.b) && ($2 != %gameadmin)) { .set %team.b $instok($remtok(%team.b,$nick,1,32),?,5,32) | .dec %beta.slots | .check_move_a } 
  elseif ($2 isincs %team.a) { .set %team.a $instok($remtok(%team.a,$nick,1,32),?,5,32) | .dec %alpha.slots | .check_move_b }
}

alias check_move_a {
  if (%alpha.slots != 5) {
    set %team.a $reptok(%tean.a,?,$2,1,32)
    .inc %alpha.slots
    .msgteams
  }

  alias check_move_b {
    if (%beta.slots != 5) {
      set %team.b $reptok(%tean.b,?,$2,1,32)
      .inc %beta.slots
      .msgteams
    }

    on *:text:!next:%main:{
      if (%nextadmin == $null) { .msg %main :[]: There are no admins in my list - Please be patient... :[]: } 
      else { .msg %main :[]: The next game will be done by %nextadmin :[]: }
    }

    on *:text:!remove:%main:{
      if (%add == allowed) {
        nick_rem_msg
      } 
    }

    alias check_user_a {
      if (($nick !isincs %team.a) && ($nick !isincs %team.b)) { add_team_a }
      else { .nick_rem_func | add_team_a }
    }

    alias add_team_a {
      if (%alpha.slots != 5) {
        elseif ($nick == %gameadmin) { colour_teams_a }
        else { set %team.a $reptok(%team.a,?,$nick,1,32) | .inc %alpha.slots | .inc %totalslots | .msgteams } 
      }
    }

    alias colour_teams_a {
      if (%alpha.slots != 5) {
        set %team.a $reptok(%team.a,?,7 $+ $nick $+ ,1,32)
        .inc %alpha.slots
        .inc %totalslots
        .msgteams
      }
    }

    alias check_user_b {
      if (($nick !isincs %team.b) && ($nick !isincs %team.a)) { add_team_b }
      else { .nick_rem_func | add_team_b }
    }


    alias add_team_b {
      if (%beta.slots != 5) {
        elseif ($nick == %gameadmin) { colour_teams_b }
        else { set %team.b $reptok(%team.b,?,$nick,1,32) | .inc %beta.slots | .inc %totalslots | .msgteams } 
      }
    }

    alias colour_teams_b {
      if (%beta.slots != 5) {
        set %team.b $reptok(%team.b,?,7 $+ $nick $+ ,1,32)
        .inc %beta.slots
        .inc %totalslots
        .msgteams
      }
    }

    alias nick_rem_func {
      if ($nick isincs %team.a) { set %team.a $instok($remtok(%team.a,$nick,1,32),?,5,32) | .dec %alpha.slots | .dec %totalslots }
    elseif ($nick isincs %team.b) set %team.b $instok($remtok(%team.b,$nick,1,32),?,5,32) | .dec %beta.slots | .dec %totalslots }
  }

  alias nick_rem_msg {
    if ($nick isincs %team.a) { set %team.a $instok($remtok(%team.a,$nick,1,32),?,5,32) | .dec %alpha.slots | .dec %totalslots | .msgteams }
  elseif ($nick isincs %team.b) set %team.b $instok($remtok(%team.b,$nick,1,32),?,5,32) | .dec %beta.slots | .dec %totalslots | .msgteams }
  else { .notice $nick :[]: You are not in a team ! :[]: }
}

alias msgteams {
  msg %main 5Current10 ( $+ %totalplayers $+ /10) 12Team Alpha:2 $seperator(%team.a) :: 12Team Beta:2 $seperator(%team.b)
  .unset %seperator
  .check_game
}

alias seperator {
  var %a = 2
  set %seperator $1
  while (%a <= 8) {
    set %seperator $instok(%seperator,-,%a,32)
    inc %a 2
  }
  return %seperator
}

alias check_game {
  if (%totalslots == 10) {
    mode %main +Mm
    set %add notallowed
    set %getpass allowed
    ;  settings2
    msg %main :[]: The teams are now full ! :[]:
    topic %main 1:[]: Welcome to %main :[]:
    msg %main >> The Server-Information will be sent to you inside 5 minutes .:. If there is any problem with getting the information, please type !getpass after the -M or better, contact the current admin %gameadmin <<
    msg %main :[]: Thank you for joining %main ! :[]:
    msg $gettok(%team.a, 1, 32) :[]: Server information .:. IP : %gameip .:. Password: %gamepass .:. Your admin is %gameadmin :: Please connect to the server as fast as possible and join Team Alpha(CTS)! :[]:
    msg $gettok(%team.a, 2, 32) :[]: Server information .:. IP : %gameip .:. Password: %gamepass .:. Your admin is %gameadmin :: Please connect to the server as fast as possible and join Team Alpha(CTS)! :[]:
    msg $gettok(%team.a, 3, 32) :[]: Server information .:. IP : %gameip .:. Password: %gamepass .:. Your admin is %gameadmin :: Please connect to the server as fast as possible and join Team Alpha(CTS)! :[]:
    msg $gettok(%team.a, 4, 32) :[]: Server information .:. IP : %gameip .:. Password: %gamepass .:. Your admin is %gameadmin :: Please connect to the server as fast as possible and join Team Alpha(CTS)! :[]:
    msg $gettok(%team.a, 5, 32) :[]: Server information .:. IP : %gameip .:. Password: %gamepass .:. Your admin is %gameadmin :: Please connect to the server as fast as possible and join Team Alpha(CTS)! :[]:
    msg $gettok(%team.b, 1, 32) :[]: Server information .:. IP : %gameip .:. Password: %gamepass .:. Your admin is %gameadmin :: Please connect to the server as fast as possible and join Team Beta(Terror)! :[]:
    msg $gettok(%team.b, 2, 32) :[]: Server information .:. IP : %gameip .:. Password: %gamepass .:. Your admin is %gameadmin :: Please connect to the server as fast as possible and join Team Beta(Terror)! :[]:
    msg $gettok(%team.b, 3, 32) :[]: Server information .:. IP : %gameip .:. Password: %gamepass .:. Your admin is %gameadmin :: Please connect to the server as fast as possible and join Team Beta(Terror)! :[]:
    msg $gettok(%team.b, 4, 32) :[]: Server information .:. IP : %gameip .:. Password: %gamepass .:. Your admin is %gameadmin :: Please connect to the server as fast as possible and join Team Beta(Terror)! :[]:
    msg $gettok(%team.b, 5, 32) :[]: Server information .:. IP : %gameip .:. Password: %gamepass .:. Your admin is %gameadmin :: Please connect to the server as fast as possible and join Team Beta(Terror)! :[]:
    .inc %mystats. [ $+ [ $gettok(%team.a,1,32) ] ]
    .inc %mystats. [ $+ [ $gettok(%team.a,2,32) ] ]
    .inc %mystats. [ $+ [ $gettok(%team.a,3,32) ] ]
    .inc %mystats. [ $+ [ $gettok(%team.a,4,32) ] ]
    .inc %mystats. [ $+ [ $gettok(%team.a,5,32) ] ]
    .inc %mystats. [ $+ [ $gettok(%team.b,1,32) ] ]
    .inc %mystats. [ $+ [ $gettok(%team.b,2,32) ] ]
    .inc %mystats. [ $+ [ $gettok(%team.b,3,32) ] ]
    .inc %mystats. [ $+ [ $gettok(%team.b,4,32) ] ]
    .inc %mystats. [ $+ [ $gettok(%team.b,5,32) ] ]
    write_stats
    .inc %adminstats. [ $+ [ %gameadmin ] ]
    .inc %totalgames
    set %teams Teams on $fulldate :: TeamAlpha: $seperator(%team.a)  TeamBeta: $seperator(%team.b) - The admin is %gameadmin
    /writeini -n games.ini %gameadmin %teams
    .timerallow_game 1 600 /set %game allowed
    mode %main -Mm
  }
}

alias write_stats {
  .writeini -n stats.ini $gettok(%team.a,1,32) Games %mystats. [ $+ [ $gettok(%team.a,1,32) ] ]
  .writeini -n stats.ini $gettok(%team.a,2,32) Games %mystats. [ $+ [ $gettok(%team.a,2,32) ] ]
  .writeini -n stats.ini $gettok(%team.a,3,32) Games %mystats. [ $+ [ $gettok(%team.a,3,32) ] ]
  .writeini -n stats.ini $gettok(%team.a,4,32) Games %mystats. [ $+ [ $gettok(%team.a,4,32) ] ]
  .writeini -n stats.ini $gettok(%team.a,5,32) Games %mystats. [ $+ [ $gettok(%team.a,5,32) ] ]
  .writeini -n stats.ini $gettok(%team.b,1,32) Games %mystats. [ $+ [ $gettok(%team.b,1,32) ] ]
  .writeini -n stats.ini $gettok(%team.b,2,32) Games %mystats. [ $+ [ $gettok(%team.b,2,32) ] ]
  .writeini -n stats.ini $gettok(%team.b,3,32) Games %mystats. [ $+ [ $gettok(%team.b,3,32) ] ]
  .writeini -n stats.ini $gettok(%team.b,4,32) Games %mystats. [ $+ [ $gettok(%team.b,4,32) ] ]
  .writeini -n stats.ini $gettok(%team.b,5,32) Games %mystats. [ $+ [ $gettok(%team.b,5,32) ] ]
}

on *:text:!getpass:%main:{
  if (%getpass == allowed) {
    elseif ($nick isincs %team.a) { .msg $nick :[]: Server information .:. IP : %gameip .:. Password: %gamepass :: Please connect to the server as fast as possible and join Team Alpha(CTS)! :[]: }
    elseif ($nick isincs %team.b) { .msg $nick :[]: Server information .:. IP : %gameip .:. Password: %gamepass :: Please connect to the server as fast as possible and join Team Beta(Terror)! :[]: }
  }
}

on *:text:!startgame * *:?:{
  if (%game == allowed) {
    check_admin
    msg $nick :[]: Server information IP: %gameip and Password: %gamepass is ok ? :[]:
  }
}
on *:text:!type *:%main,%prv:{
  if ((%game == allowed) && ($nick == %gameadmin)) {
    set %gametype $2-
    set_topic
  }
}

on *:text:!map *:%main,%prv:{
  if ((%game == allowed) && ($nick == %gameadmin)) {
    set %gamemap $2
    set_topic
  }
}

alias set_topic {
  topic %main 1:[]: Go subscribe ! .:. Type: %gametype .:. Current Map: %gamemap .:. Your admin is $nick ! :[]:
}


on *:text:!info ok:?:{
  if ($nick == %gameadmin) {
    start_game
  }
}

alias check_admin {
  if ($nick == %nextadmin) {
    set %gameadmin $nick
    set %gameip $2
    set %gamepass $3
  }
}


on *:text:!teams:%main:{
  if (%add == allowed) {
    msgteams
  }
}

on *:text:!mystats:%main,%prv:{
  if (%mystats. [ $+ [ $nick ] ]) { .notice $nick 1:[]: You have joined $gettok(%mystats. [ $+ [ $nick ] ],1,32) games so far... :[]:
    else { .notice $nick 1:[]: There are no statistics available for you... Join some games ;) :[]:  }
  }

  on *:text:!mygames:%prv:{
    if (%adminstats. [ $+ [ $nick ] ]) { .notice $nick 1:[]: You have managed $gettok(%adminstats. [ $+ [ $nick ] ],1,32) games so far... :[]:
      else { .notice $nick 1:[]: You have no games managed for this month... :[]:  }
    } 

    on *:text:!stats *:%prv:{
      if ($read(admins.txt,*$nick*)) {
        msg %prv :[]: Stats for $2 : He/She has joined $gettok(%mystats. [ $+ [ $2 ] ],1,32) and has managed $gettok(%adminstats. [ $+ [ $2 ] ],1,32) games this month ! :[]: 
      }
    }

    on *:text:!totalgames:%main:{
      if (%totalgames > 0) { msg %main :[]: Total games for this month: %totalgames :[]: }
      else { msg %main :[]: No games have been made this month... :[]: }
    }

    on *:text:!clearstats:?:{
      if ($nick == %headadmin) {
        set %totalgames 0
        ;clear_player_stats
      }
    }

    alias clear_player_stats {
      .writeini -n stats.ini $gettok(%team.b,1,32) Games %mystats. [ $+ [ $gettok(%team.b,1,32) ] ]
    }



    ; Queue

    on *:text:!queue:%prv:{
      msg %prv :[]: Queue-List ($+ %queueslots $+ /8): %queue :[]:
    }

    on *:text:!setmenext:%prv:{
      if ($nick !isincs %queue) { .set %queue $reptok(%queue, ?, $nick, 1, 32) | .inc %queueslots | .set %nextadmin $gettok(%queue,1,32) | .msg_queue }
    }

    alias msg_queue {
      msg %prv :[]: Queue-List ($+ %queueslots $+ /8): %queue :[]:
    }

    on *:text:!delme:%prv:{
      if ($nick isincs %queue) { .set %queue $instok($remtok(%queue,$nick,1,32),?,5,32) | .dec %queueslots | .set %nextadmin $gettok(%queue,1,32) | .msg_queue }
    }

    on *:text:!del *:%prv:{
      if (($nick isop %prv) && ($2 isincs %queue)) { .set %queue $instok($remtok(%queue,$2,1,32),?,5,32) | .dec %queueslots | .set %nextadmin $gettok(%queue,1,32) | .msg_queue }
    }
