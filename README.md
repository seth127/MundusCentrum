# MundusCentrum
An open source long form strategy, tactics, and logistics war game, heavily inspired by Warhammer 40k and the blog of Brett Devereux

Check out the "Sample Game" vignette for basics.

## To Do

* Move these to issues
* Map legal moves and territories bordering each other
  * Static file, loaded on package load
* Attributes of different types
  * Static file, loaded on package load
* Mutable attributes of units. Stats. Stuff.
* testthat. 
  * new_game
  * move_unit
  * reconcile_player_orders
* Roxygen docs
* Getters in reconcile map private?
* Reorganize and rename stuff in reconcile-map.R and turn.R

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
