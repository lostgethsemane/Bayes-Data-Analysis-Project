data {
    int<lower=0> N; 
    vector[N] x; 
    vector[N] y; 
}

parameters {
    real alpha;           
    real beta;    
    real<lower=0> sigma; 
}

model {
    alpha ~ normal(55, 2.5);
    beta ~ normal(-0.63, 0.15);
    sigma ~ cauchy(0, 5);  
    
    // likelihood
    y ~ normal(alpha + beta * x, sigma);
}

generated quantities { 
    vector[N] y_sim; 
    real log_lik[N];      
    
    for (i in 1:N) {
        y_sim[i] = normal_rng(alpha + beta * x[i], sigma);
        log_lik[i] = normal_lpdf(y[i] | alpha + beta * x[i], sigma);
    }
}
