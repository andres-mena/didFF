#' Test if Parallel trends assumption is sensitive to functional form
#'
#' @param DF data.frame object
#' @param yvar Name of Outcome variable in df
#' @param tvar Name Time variable in df
#' @param treatmentvar Name of Binary variable in df indicating treatment/control group
#' @param nbins A scalar indicating the Number of bins for the support of Outcome. Default nbins=100
#' @param starting_year The Baseline period for DID. Default min(tvar)
#' @param ending_year The follow up period for DID. Default max(tvar)
#'
#' @return A plot of the implied density under the null
#' @export
#'
#' @examples
#'set.seed(99)
#'N=10000
#'treat<-rbinom(N,1,0.25)
#'wage<-rlnorm(N, 13, 2)
#'id<-as.character(seq(1:N))
#'t0<-replicate(N,2010)
#'t1<-replicate(N,2020)
#'y0<-wage+rnorm(N,0,100)
#'y1<- y0 + 20*treat + rnorm(N,0,100)
#'panel_id=c(paste(id,t0,sep="_"),paste(id,t1,sep="_"))
#'year<-c(t0,t1)
#'y<-c(y0,y1)
#'D<-c(treat,treat)
#'treated<-c(replicate(N,0),treat)
#'ID<-c(id,id)
#'df<-data.frame(panel_id,ID,year,y,D,treated)
#'df<-df%>%dplyr::filter((0 <= y) & (y <= 500000))
#'TestFunctionalForm(df,y,year,D,1000)

TestFunctionalForm<-function(DF=NULL,
                             yvar,
                             tvar,
                             treatmentvar,
                             nbins=100,
                             starting_year=NULL,
                             ending_year=NULL){
  y<-deparse(substitute(yvar))
  t<-deparse(substitute(tvar))
  treatment<-deparse(substitute(treatmentvar))

  df1<-iDiscretize(DF,y,t,treatment,nbins)

  implied_density_table<-iDensity(df1,starting_year,ending_year)

  implied_density_plot <- iDensityPlot(implied_density_table)
  return(implied_density_plot)
}
