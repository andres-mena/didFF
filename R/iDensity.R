iDensity <-function(DF=NULL,
                    starting_year=NULL,
                    ending_year=NULL){

  df1<-DF #Data frame resulting from iDiscretize()
  if (is.null(starting_year)) {
    sy<-min(df1$year)
  } else {
    sy<-starting_year
  }
  if (is.null(ending_year)) {
    ey<-max(df1$year)
  } else {
    ey<-ending_year
  }

  #Compute Density by year-treatment-bin
  long_summary_table <-
    df1 %>%
    dplyr::group_by(year, D, level) %>%
    dplyr::summarise(count = dplyr::n(), .groups = "keep") %>%
    dplyr::group_by(D, year) %>%
    dplyr::mutate(density = prop.table(count)) %>%
    dplyr::select(-count)


  #Reshape wide so that each row is wage-bin and each column is a year-by-treatment-status
  wide_summary_table <-
    long_summary_table %>%
    tidyr::pivot_wider(id_cols = c(level),
                       names_from = c(year, D),
                       values_from = density,
                       values_fill = 0)

  wide_summary_table$implied_density_post <- wide_summary_table[[glue::glue("{sy}_1")]] +
    wide_summary_table[[glue::glue("{ey}_0")]] - wide_summary_table[[glue::glue("{sy}_0")]]

  return(wide_summary_table)
}#Returns a data.frame object in wide format ready for iDensityPlot
