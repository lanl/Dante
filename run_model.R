# Load required library
library('rjags')

# Set path to code
filepath = "~/spaceflu/tasks/flu/task0/manuscripts/submissions/Nature_Communications_Submission/second_submission/MWE/" 

# Load data, which takes the form of a list.
# NOTE: Ordering between elements in list entries must be consistent 
# (e.g., order of states in dat_state and census_weights must match).
load(paste0(filepath,'dat.Rdata'))
str(dat) # See structure of data.

# Add small nonzero value to the ILI=0 entries 
dat$yobs_state[dat$yobs_state==0] = 0.0005

# Compile the model.
mod <- jags.model(file = paste0(filepath,"Dante.bug"),
                  data = dat,
                  n.chains = 1,   # One chain used for illustrative purposes, could increase. 
                  n.adapt = 1000) # Burn-in for 1000 iterations, could increase.

# Generate posterior samples from the model in mcmc.list format.
# Note we only request samples from national (futurey_nat) and 
# state (futurey_state) forecasts and the state-specific precision parameter (lambda), 
# but regional forecasts (futurey_hhs) and individual model components 
# (e.g., mu_all, mu_season, etc shown in Fig 5) could also be requested by 
# adding to the variable.names input.
res <- coda.samples(model = mod, 
                    variable.names = c('futurey_nat','futurey_state','lambda'), 
                    n.iter = 2000) # Number of iterations could be increased.

# View the draws for lambda for states 1 and 5.
plot(log(res[[1]][,'lambda[1]']), main=expression(Samples~of~Lambda[1]))
plot(log(res[[1]][,'lambda[5]']), main=expression(Samples~of~Lambda[5]))

# View the predicted ILI trajectory for national level...
rgn = 1 # ... or uncomment below and choose a state (1, ..., 9) to view.
mat_disp = matrix(NA,nrow=dat$NT,ncol=3)
for(t in 1:(dat$NT)){
  #tmp = res[[1]][,paste0('futurey_state[',rgn,',',t,']')] # Uncomment to view state data.
  tmp = 100*res[[1]][,paste0('futurey_nat[',t,']')] # Comment and uncomment above for state.
  mat_disp[t,2] = mean(tmp)
  mat_disp[t,c(1,3)] = quantile(tmp, c(0.025,0.975))
}
# Plot observed ILI, then overlay model predictions for the rest of the season.
plot( 1:(dat$NT), c(mat_disp[1:(dat$nobs),2],rep(NA,dat$NT-dat$nobs)), ylim=range(c(0,mat_disp)),
      xlab='Epi time', ylab='ILI')
inds=(dat$nobs+1):(dat$NT); lines(inds,mat_disp[inds,2]) # Predicted mean ILI.
lines(inds,mat_disp[inds,1], lty=2); lines(inds,mat_disp[inds,3], lty=2) # Predicted 95% credible interval.
