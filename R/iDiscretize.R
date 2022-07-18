iDiscretize<-function(DF=NULL,
                            idvar="id",
                            yvar="outcome",
                            tvar="year",
                            treatmentvar="treatment",
                            weight=NULL,
                            scale=NULL,
                            nbins=NULL)
                            {

if (is.null(nbins)){
  bin<-as.numeric(DF[[yvar]])
  level<-as.numeric(DF[[yvar]])}
  else{
   bin <- as.numeric(cut(DF[[yvar]],
                        breaks=nbins,
                        include.lowest=TRUE,
                        labels=FALSE))

  level<-as.numeric( sub("[^,]*,([^]]*)\\]", "\\1",cut(DF[[yvar]],
                                                       breaks=nbins,
                                                       include.lowest=TRUE)) )}

  y <- as.numeric(DF[[yvar]])
  year <- DF[[tvar]]
  D<-DF[[treatmentvar]]
  id<-DF[[idvar]]

  if (is.null(weight)) {
    w<-rep(1, length(y))
  } else {
    w<-DF[[weight]]}

  if (is.null(scale)) {
    iscale<-rep(1, length(y))
  } else {
    iscale<-DF[[scale]]}

  df1<-data.frame(id,bin,level,y,year,D,w,iscale)

  return(df1)
} #Discretize the support of y for density estimation and return a df ready for TestFunctionalForm
