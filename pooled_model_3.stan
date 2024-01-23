data {
    int<lower=0> N; //number of data points
    vector[N] x; //bill depth
    vector[N] y; //bill length
}

parameters {
    real alpha;//intercept
    real beta; //slope
    real<lower=0> sigma; //scatter
}

model {
    //biased priors
    alpha ~ uniform(-10, 10);
    beta ~ cauchy(0, 5);
    sigma ~ normal(0,4);
    
    y ~ normal(alpha + beta * x, sigma); 
}

generated quantities { 
    vector[N] y_sim; 
    real log_lik[N];      
    
    for(i in 1:N){
	    y_sim[i] = normal_rng(alpha + beta * x[i], sigma);
	    log_lik[i] = normal_lpdf(y[i] | alpha + beta * x[i], sigma);
    }
}

