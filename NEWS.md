# Stype.est 0.2.0

## Performance improvements

* `regstype()` function optimized:
  - Replaced `lm()` with `lm.fit()` for initial fit
  - `regweighteds()` now called only once at end of loop
    instead of every iteration
  - Vectorized weight computation (removed inner for loops)
  - Replaced manual normal density formula with `dnorm()`
  - Simplified x/y input handling using `as.matrix()`
