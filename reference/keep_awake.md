# keep_awake

Prevent the machine from going to sleep during a long computation, and
allow it again afterwards.

This exists because a system sleep is invisible to every in-process
measurement. While the machine is asleep wall clock advances and CPU
time does not, so a step that spans a sleep appears many times slower
while doing identical work: recorded pipeline timings have been inflated
5-14x this way, with CPU-seconds, memory and I/O counters all looking
entirely normal.

**Nothing in Giotto holds a sleep assertion unless you call
`keep_awake()` or
[`gwith_awake()`](https://giotto-suite.github.io/GiottoUtils/reference/with.md).**
Attaching the package changes no power settings.

## Usage

``` r
keep_awake(on = TRUE)
```

## Arguments

- on:

  logical. `TRUE` holds the assertion, `FALSE` releases it.

## Value

`TRUE` if an assertion is held after the call, otherwise `FALSE`,
invisibly

## Details

Uses `caffeinate` on macOS and `systemd-inhibit` on Linux; on other
platforms, or when neither is available, it reports that it cannot help
and does nothing. No sleep assertion can outlive the R session: on both
platforms the helper is bound to this process and exits with it. For the
same reason, sessions running side by side on one machine hold and
release independently.

Idempotent within a session — calling it repeatedly with `on = TRUE`
leaves a single helper. A session only ever tracks and releases the
helper it started itself, so it cannot report another session's hold as
its own.

## Options

- `giotto.prevent_sleep`:

  when `FALSE`, `keep_awake(TRUE)` and
  [`gwith_awake()`](https://giotto-suite.github.io/GiottoUtils/reference/with.md)
  become no-ops (default `TRUE`). This is a kill switch for shared
  machines, cluster nodes and CI, where holding a power assertion is
  unwanted; it does **not** cause anything to hold one on its own. It
  gates taking an assertion only — `keep_awake(FALSE)` still releases
  one that is already held, so setting the option partway through cannot
  strand it.

## See also

[`gwith_awake()`](https://giotto-suite.github.io/GiottoUtils/reference/with.md)
to scope it to a block of code

## Examples

``` r
if (FALSE) { # \dontrun{
keep_awake(TRUE)
# ... long pipeline ...
keep_awake(FALSE)
} # }
```
