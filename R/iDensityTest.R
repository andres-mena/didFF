iDensityTest <- function(DF=NULL,
                                     idvar="id variable",
                                     yvar="outcome",
                                     tvar="year",
                                     treatmentvar="treatment",
                                     nbins=100,
                                     numBootstrapDraws = 1000,
                                     starting_year=NULL,
                                     ending_year=NULL
                                     ){
  df1<-iDiscretize(DF,idvar, yvar, tvar, treatmentvar, nbins)
  data<-df1 #A data.frame coming from iDiscretize

  #Compute the implied density on actual data
  implied_density_post_df <- iDensity(data, starting_year, ending_year)

  #Compute the implied_density for each bootstrap draw
  bootStrapResults <- purrr::map_dfr(.x=1:numBootstrapDraws,
                                     .f = ~iDensity(boot_id(data,"id",.x),
                                                    starting_year,
                                                    ending_year
                                                    )%>%
                                       dplyr::mutate(nboot = .x))
  # #Compute the covariance matrix of moments over the bootstrap draws
   sigma <-
     bootStrapResults %>%
     dplyr::select(level, implied_density_post, nboot) %>%
     tidyr::pivot_wider(names_from = level,
                        id_cols = nboot,
                        values_from = implied_density_post) %>%
      dplyr::select(-nboot)%>%
      as.matrix() %>%
      cov()

  # #Do moment inequality test
  # #This function tests that all moments are <=0, so we reverse the sign of the implied densities
      p_value <- lf_moment_inequality_test(muhat = -implied_density_post_df$implied_density_post,
                                           Sigmahat = sigma,
                                           numSims = dim(sigma)[1])

  return(p_value)
}
