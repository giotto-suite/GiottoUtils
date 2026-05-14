# Verbose message handler

Verbose message handler

## Usage

``` r
vmsg(
  ...,
  .v = NULL,
  .is_debug = FALSE,
  .vopt = getOption("giotto.verbose", TRUE),
  .log_path = NULL
)
```

## Arguments

- ...:

  additional strings and/or elements to pass to wrap_msg

- .v:

  verbose flag to pass. Will check options through .vopt if NULL
  (default). This param is intended for passing function-level verbose
  flags

- .is_debug:

  flag as a debug print (only prints when .v or .vopt is 'debug')

- .vopt:

  global verbosity option to pull from

- .log_path:

  filepath. Temporarily log to a specific location. Does not disturb the
  `"giotto.last_logpath"` option.

## Value

character

## Examples

``` r
# common usage (.v is logical)
vmsg("print me", .v = TRUE)
#> print me
vmsg("dont print me", .v = FALSE)

# debug messages (.v == "debug")
# flag as a debug message using .is_debug = TRUE
vmsg("I am a debug message", .is_debug = TRUE, .v = TRUE) # no print
vmsg("I am a debug message", .is_debug = TRUE, .v = "debug") # prints
#> I am a debug message

vmsg("print me", .v = "debug") # also prints non-debug messages
#> print me

# with global option
options("giotto.verbose" = TRUE)
vmsg("Print by default")
#> Print by default

options("giotto.verbose" = FALSE)
vmsg("Do not print by default")
vmsg("Do not print by default", .v = TRUE)
#> Do not print by default
# function level input overrides global option
```
