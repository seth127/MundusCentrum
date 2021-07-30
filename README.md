# MundusCentrum
An open source long form strategy, tactics, and logistics war game, heavily inspired by Warhammer 40k and the blog of Brett Devereux

Check out [the "Sample Game" vignette](https://seth127.github.io/MundusCentrum/sample-game) for basics.

## To Do

* Move these to issues
* s3 classes for game and game_df and maybe others (player?)
* Check legal moves
  * inside move_unit() need to check the unit's movement and location and MAP borders
  * also need to check keywords to see what's legal
    * soaring/flying penalty
    * transports
    * deep
    * what are the options for actions? (move, attack, control, soar, others?)
* Battles when crossing paths
  * need to keep track of paths on longer moves
* Dropping comm relays and control flags as you go.
* Make it so you don't have to do `draw_map(res, "CONFLICT!")` it just figures out there's conflict
* Figure out an easy helper for splitting up forces with `modify_unit()`
* Vision
  * sneaking  
  * vision of spaces passed through? (maybe only relevant to soaring?)
* Control and Comms
  * do you lose control if you leave or stop controlling (this is how it's coded now)
    * maybe add a fake "unit" that's like a flag for controlling, once it's been established
  * what's up with comm relays? Should we add them like units?
  * make sure flags and comms don't show up as units on map (or maybe they show as something else?)
* Document data
* testthat. 
  * new_game
  * move_unit
  * reconcile_player_orders
  * build_name
  * others
* Roxygen docs
* Getters in reconcile map private?
* Put filelock on `inst/extdata/name-files/USED.txt` (and probably some others: player files, map, etc.)
* Consider UI
  * shiny stuff
  * move files to database so they persist across shiny sessions
  * users and passwords so each player gets different UI
  * emails to players on turn advance and conflict

## Development

`MundusCentrum` uses [pkgr](https://github.com/metrumresearchgroup/pkgr) to manage
development dependencies and [renv](https://rstudio.github.io/renv/) to
provide isolation. To replicate this environment,

1.  clone the repo

2.  [install pkgr](https://github.com/metrumresearchgroup/pkgr#getting-started)

3.  open package in an R session and run `renv::init()`
    
      - install `renv` \> 0.8.3-4 into default `.libPaths()` if not
        already installed

4.  run `pkgr install` in terminal within package directory

5.  restart session

Then, launch R with the repo as the working directory (open the project
in RStudio). renv will activate and find the project library.
