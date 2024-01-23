// Hierarchical model - sensitivity analysis

data {
  int<lower=0> N;
  int<lower=1> J_species;
  int<lower=1, upper=J_species> species[N];
  vector[N] bill_depth;
  vector[N] bill_length;
}

parameters {
  real alpha;
  real beta;
  vector[J_species] gamma;
  real<lower=0> sigma_species;
  real<lower=0> sigma;
}

model {
  // Priors
  alpha ~ uniform(-10, 10);
  beta ~ uniform(-10, 10);
  gamma ~ student_t(3, 0, 1);
  sigma_species ~ lognormal(0, 1);
  sigma ~ lognormal(0, 1);

  for (i in 1:J_species) {
    gamma[i] ~ normal(5, sigma_species);
  }

  // Likelihood
  for (n in 1:N) {
    bill_length[n] ~ normal(alpha + beta * bill_depth[n] + gamma[species[n]], sigma);
  }
}

generated quantities {
  real output[N];
  real log_lik[N];

  for (n in 1:N) {
    log_lik[n] = normal_lpdf(bill_length[n] | alpha + beta * bill_depth[n] + gamma[species[n]], sigma);
    output[n] = normal_rng(alpha + beta * bill_depth[n] + gamma[species[n]], sigma);
  }
}