#' Test if Parallel trends assumption is sensitive to functional form
#'
#' @param DF data.frame object
#' @param yvar Name of Outcome variable in DF
#' @param tvar Name Time variable in DF
#' @param treatmentvar Name of Binary variable in df indicating treatment/control group
#' @param nbins A scalar indicating the Number of bins for the support of Outcome. Default nbins=100
#' @param starting_year The Baseline period for DID. Default min(tvar)
#' @param ending_year The follow up period for DID. Default max(tvar)
#' @param idvar Name variable indicating group or id in DF
#' @param weight Name weighting variable. Default is NULL
#' @param scale Name scale variable. Default is NULL
#' @param nboots Number of bootstrap samples for iDensityTest. Default nboots=1000
#' @param seed Starting seed for iDensityTest. Default is random.
#' @param minbin Minimun outcome-bin for density estimation. Default minbin=NULL
#' @param maxbin Maximun outcome-bin for density estimation. Default maxbin=NULL
#'
#' @return A plot of the implied density under the null and pval for H0= Implied Density>0
#' @export
#'
#' @examples


TestFunctionalForm<-function(DF=NULL,
                             idvar = "id",
                             yvar = "output",
                             tvar= "time",
                             treatmentvar = "treatment group",
                             weight=NULL,
                             scale=NULL,
                             nbins=NULL,
                             nboots=1000,
                             seed=0,
                             starting_year=NULL,
                             ending_year=NULL,
                             minbin = NULL,
                             maxbin = NULL
                             ){


  df1<-iDiscretize(DF,idvar,yvar,tvar,treatmentvar,weight,scale,nbins)

  implied_density_table<-iDensity(df1,starting_year,ending_year)
  if (is.null(minbin)) {
    min<-base::min(implied_density_table$level)
  } else {
    min<-minbin
  }

  if (is.null(maxbin)) {
    max<-base::max(implied_density_table$level)
  } else {
    max<-maxbin
  }
  plotTable <- implied_density_table%>%
    dplyr::filter(min <= level, level <= max)%>%
    dplyr::mutate(Outcome = level) %>%
    dplyr::mutate(`Implied Density` = ifelse(implied_density_post < 0,
                                             "Negative", "Non-negative"))

  implied_density_plot <- iDensityPlot(plotTable,starting_year,ending_year)

  pval <- iDensityTest(DF,idvar,yvar,tvar,treatmentvar,weight,scale,nbins,nboots,seed,starting_year,ending_year)

  rpval<-round(pval,3)
  H0_text = latex2exp::TeX("\\textbf{$H_0$} \\textbf{: Implied Density} \\textbf{$\\geq 0$}")
  pval_text= latex2exp::TeX(paste("\\textbf{p-value <",rpval,"}"))


  plot<-implied_density_plot +
    ggplot2::annotate(geom = 'text',
             x = base::mean(plotTable$level)+stats::sd(plotTable$implied_density_post),
             y = base::max(plotTable$implied_density_post),
             label = H0_text,
             hjust = 0) +
    ggplot2::annotate(geom = 'text',
             x = base::mean(plotTable$level)+stats::sd(implied_density_table$implied_density_post),
             y = base::max(plotTable$implied_density_post)-stats::sd(plotTable$implied_density_post)/3,
             label = pval_text,
             hjust = 0) +
    ggplot2::xlab(yvar)

  return(plot)


}

