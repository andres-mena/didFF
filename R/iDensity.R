iDensity <-function(DF=NULL,
                    starting_year=NULL,
                    ending_year=NULL){

  df2<-DF #Data frame resulting from iDiscretize()
  if (is.null(starting_year)) {
    sy<-min(df2$year)
  } else {
    sy<-starting_year
  }
  if (is.null(ending_year)) {
    ey<-max(df2$year)
  } else {
    ey<-ending_year
  }

#Compare pre post
  compare_pre_post <-
    df2 %>%
    dplyr::filter((sy <= year) & (year <= ey)) %>%
    dplyr::group_by(id) %>%
    dplyr::mutate(treated_in_period = max(D > 0)) %>% #was your state ever treated in this period
    dplyr::group_by(treated_in_period) %>%
    dplyr::filter((year == sy) | (year == ey)) #filter to pre and post

  #Compute Density by year-treatment-bin
  long_summary_table <-
    compare_pre_post %>%
    dplyr::group_by(year, level, treated_in_period) %>%
    dplyr::summarise(idensity = Hmisc::wtd.mean(iscale, w = w), .groups = "keep")


  #Reshape wide so that each row is wage-bin and each column is a year-by-treatment-status
  wide_summary_table <-
    long_summary_table %>%
    tidyr::pivot_wider(id_cols = c(level),
                       names_from = c(year, treated_in_period),
                       values_from = idensity,
                       values_fill = 0)

  wide_summary_table$implied_density_post <- wide_summary_table[[glue::glue("{sy}_1")]] +
    wide_summary_table[[glue::glue("{ey}_0")]] - wide_summary_table[[glue::glue("{sy}_0")]]

  return(wide_summary_table)
} #Returns a data.frame object in wide format ready for iDensityPlot
