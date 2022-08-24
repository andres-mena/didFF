
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TestFunctionalForm

<!-- badges: start -->
<!-- badges: end -->

The TestFunctionalForm R package assesses when the validity of
difference-in-differences and related estimators depends on functional
form, based on the theoretical results in [Roth and Sant’Anna
(2022)](https://jonathandroth.github.io/assets/files/2010.04814.pdf).
This package provides a test for the insensitivity of parallel trends to
functional form by estimating the implied density of potential outcomes
and checking if its significantly below zero at some point.

## Installation

You can install the development version of TestFunctionalForm from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("amenabrown/TestFunctionalForm")
```

## Example

We now provide and example of how to use the package by re-creating the
Empirical Illustration in [Roth and Sant’Anna (2022,
p.11)](https://jonathandroth.github.io/assets/files/2010.04814.pdf). We
use data from [Cengiz et
al. (2019)](https://doi.org/10.1093/qje/qjz014), who compile panel data
on state-level minimum wages and employment-to-population ratios in
25-cents wage-bins.

## Loading the package and the data

``` r
library(TestFunctionalForm) #load the TestFunctional Form package
df<-TestFunctionalForm::Cengiz_df #load Cengiz et al. (2019) data frame
```

## Testing Functional Form for DiD between 2007 and 2015

Our pre-treatment period is 2007, our post-treatment period is 2015, and
the treatment is whether a state raised its minimum wage at any point
between the pre-treatment and post-treatment periods. The outcome of
interest is individual wages Wi (where Wi=0 if i is not working). We are
going to test if DiD is sensitive to functional form of the outcome
between periods 2007 and 2015.

``` r
TestFunctionalForm(DF=df,
                                  idvar="statenum", 
                                  yvar="wagebins",  
                                  tvar="year", 
                                  treatmentvar = "treated", 
                                  weight = "w", 
                                  nboots = 1000, 
                                  seed=0, 
                                  start_t=2007, 
                                  end_t=2015, 
                                  minbin=500, 
                                  maxbin=2999
                   )
#> Warning in is.na(x): is.na() applied to non-(list or vector) of type
#> 'expression'

#> Warning in is.na(x): is.na() applied to non-(list or vector) of type
#> 'expression'
```

<img src="man/figures/README-2007-2015-1.png" width="100%" /> The plot
shows the implied counterfactual density under parallel trends of
distributions. The figure shows that the implied density is negative for
wages between approximately $5-7/hour. Using a bootstrap at the state
level for computing variance-covariance matrix of the density and then
compare the minimum studentized value to a “least-favorable” critical
value for moment inequalities that assumes all of the moments have mean
0 (see, e.g., Section 4.1.1 of [Canay and Shaikh
(2017)](https://www.econstor.eu/bitstream/10419/130095/1/846741482.pdf))
we are able to reject the null hypothesis that all of the implied
densities are positive (p\<0.001). We thus reject the null of parallel
trends of CDFs in this context, which in turn implies that parallel
trends cannot hold for all monotonic transformations of the outcome.

## Testing Functional Form for DiD between 2010 and 2015

By contrast, results using the period 2010-2015 shows that the estimated
counterfactual distribution has positive density nearly everywhere, and
we cannot formally reject the hypothesis that it is positive everywhere
(p=0.293). This does not necessarily imply that parallel trends holds
for all transformations of the outcome, but insensitivity to functional
form is not rejected by the data in this example.

``` r
TestFunctionalForm(DF=df,
                                  idvar="statenum", 
                                  yvar="wagebins",  
                                  tvar="year", 
                                  treatmentvar = "treated", 
                                  weight = "w", 
                                  nboots = 1000, 
                                  seed=0, 
                                  start_t=2010, 
                                  end_t=2015, 
                                  minbin=500, 
                                  maxbin=2999
                   )
#> Warning in is.na(x): is.na() applied to non-(list or vector) of type
#> 'expression'

#> Warning in is.na(x): is.na() applied to non-(list or vector) of type
#> 'expression'
```

<img src="man/figures/README-2010-2015-1.png" width="100%" />
