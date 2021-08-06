# MundusCentrum
An open source long form strategy, tactics, and logistics war game, heavily inspired by Warhammer 40k and the blog of Brett Devereux

Check out [the "Sample Game" vignette](https://seth127.github.io/MundusCentrum/sample-game) for basics.

## To Do

* Move these to issues
* Bridges
* Add the soaring layer
* Check which `unique() # if unit in multiple battles they will be duplicated` calls are really necessary
* Figure out why `#ifelse(.i != length(.l), "TRUE", "")` and  `# !isTRUE(as.logical(passing_through))` wasn't working
* Add feature where if you don't pass `.l` to `modify_unit()` it infers you're talking about where the unit currently is.
* s3 class for game object
  * print method
  * dispatches for important functions
* Check legal moves
  * inside move_unit() need to check the unit's movement and location and MAP borders
  * also need to check keywords to see what's legal
    * soaring/flying penalty
    * transports
    * deep
    * what are the options for actions? (move, attack, control, soar, others?)
* Figure out an easy helper for splitting up forces with `modify_unit()`
* Change `geom_point(size)` to points instead of counts of units
* Document data
* testthat. 
  * new_game
  * move_unit
  * reconcile_player_orders
  * build_name
  * others
* Roxygen docs
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
