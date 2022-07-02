iDiscretize<-function(DF=NULL,
                            yvar="outcome",
                            tvar="year",
                            treatmentvar="treatment",
                            nbins=100){

  df1<-DF %>%
    dplyr::mutate(
      bin = as.numeric(cut(DF[[yvar]],
                           breaks=nbins,
                           include.lowest=TRUE,
                           labels=FALSE)),
      level=as.numeric( sub("[^,]*,([^]]*)\\]", "\\1",cut(DF[[yvar]],
                                                          breaks=nbins,
                                                          include.lowest=TRUE)) ),
      y = DF[[yvar]],
      year = DF[[tvar]],
      D=DF[[treatmentvar]] )%>%

    dplyr::select(bin,level,y,year,D)
  return(df1)
} #Discretize the support of y for density estimation and return a df ready for TestFunctionalForm
