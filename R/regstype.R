#' Fit a regression model using the S-type estimators.
#' (Fully Optimized Version)
#'
#' @param x Explanatory variables (Dataframe, matrix, vector).
#' @param y Dependent variables (Dataframe, matrix, vector).
#' @return A list containing the model coefficients and diagnostics.
#' @export

regstype <- function(y, x) {
  c <- 1.548 
  maxit <- 100 
  eps <- 0.00001 
  
  f1 <- function(u, c) { 2 * (((u^2)/2 - (u^4)/(2*(c^2)) + (u^6)/(6*(c^4))) * dnorm(u)) } 
  f2 <- function(u, c) { 2 * ((c^2/6) * dnorm(u)) } 
  K <- integrate(f1, c=c, lower=0, upper=c)$value + integrate(f2, c=c, lower=c, upper=Inf)$value
  
  # Ensure strict matrix/vector types for C-level lm.fit functions
  x_mat <- as.matrix(x)
  y_vec <- as.numeric(as.matrix(y))
  
  n <- nrow(x_mat)
  p <- ncol(x_mat)
  s <- p + 1
  
  # Design matrix for fast WLS fitting (explicitly adding the intercept column)
  X_design <- cbind(1, x_mat)
  
  # FAST FIT: base R's internal linear model engine (skips lm() overhead)
  regls <- lm.fit(X_design, y_vec) 
  betals <- as.numeric(regls$coefficients)
  els <- as.numeric(regls$residuals)
  
  betas <- matrix(NA, nrow=s, ncol=maxit) 
  es <- matrix(NA, nrow=n, ncol=maxit) 
  us <- matrix(NA, nrow=n, ncol=maxit) 
  Ws <- matrix(NA, nrow=n, ncol=maxit)
  sigmas <- numeric(maxit) 
  conds <- numeric(maxit)
  
  betas[, 1] <- betals
  es[, 1] <- els
  
  sigmas[1] <- mad(es[, 1])
  us[, 1] <- es[, 1] / sigmas[1]
  
  Ws[, 1] <- (abs(us[, 1]) <= c) * ((1 - ((us[, 1]/c)^2))^2)
  
  # First fast WLS fit
  fit <- lm.wfit(x = X_design, y = y_vec, w = Ws[, 1])
  betas[, 2] <- fit$coefficients
  es[, 2] <- fit$residuals
  
  fark <- betas[, 2] - betas[, 1]
  conds[1] <- sqrt(sum(fark^2)) / sqrt(sum(betas[, 2]^2))
  
  ites <- 2
  
  while ((conds[ites-1] >= eps) && (ites < maxit)) {
    # sum(W * e^2) mathematically replicates sum(ew^2) for weighted residuals
    sigmas[ites] <- sqrt((1/(n*K)) * sum(Ws[, ites-1] * es[, ites]^2))
    
    us_curr <- es[, ites] / sigmas[ites]
    us[, ites] <- us_curr
    
    us2 <- us_curr^2
    abs_us_le_c <- abs(us_curr) <= c
    
    Ws_curr <- numeric(n)
    idx1 <- abs_us_le_c & (us2 > 0)
    Ws_curr[idx1] <- ((us2[idx1]/2) - (us2[idx1]^2)/(2*(c^2)) + (us2[idx1]^3)/(6*(c^4))) / us2[idx1]
    
    idx2 <- !abs_us_le_c
    Ws_curr[idx2] <- ((c^2)/6) / us2[idx2]
    
    Ws_curr[us2 == 0] <- 0.5 
    Ws[, ites] <- Ws_curr
    
    # FAST FIT: Bypass regweighteds() during the iterative loop entirely
    fit <- lm.wfit(x = X_design, y = y_vec, w = Ws_curr)
    
    ites <- ites + 1
    
    betas[, ites] <- fit$coefficients
    es[, ites] <- fit$residuals
    
    fark <- betas[, ites] - betas[, ites-1]
    conds[ites-1] <- sqrt(sum(fark^2)) / sqrt(sum(betas[, ites]^2))
  }
  
  # Call regweighteds ONLY ONCE at the very end to get all the diagnostics & ANOVA tables
  regtemp <- regweighteds(y, x, as.vector(Ws[, ites-1]))
  
  # Compile output list matching the original format perfectly
  z <- list(
    beta = betas[, ites], betas = betas, 
    e = regtemp$e, es = es, yhat = regtemp$yhat,
    MSE = regtemp$MSE, F = regtemp$F, sig = regtemp$sig, 
    varbeta = regtemp$varbeta, stdbeta = regtemp$stdbeta, 
    R2 = regtemp$R2, R2adj = regtemp$R2adj, 
    anovatable = regtemp$anovatable, confint = regtemp$confint, 
    ites = ites, sigmas = sigmas, sigma = sigmas[ites-1], 
    W = Ws[, ites-1], Ws = Ws, conds = conds
  )
  
  return(z)
}