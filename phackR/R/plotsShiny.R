# ==============================================================================
# Figures: p-value and effect size distributions
# ==============================================================================

#' Plot p-value distributions
#' @param simdat Simulated data from one of the p-hacking simulation functions
#' @param alpha Alpha level
#' @importFrom ggplot2 ggplot geom_histogram aes theme_light xlab ggtitle theme element_text geom_vline scale_fill_manual layer_scales ylab geom_segment geom_col scale_x_continuous scale_y_continuous waiver
#' @importFrom rlang .data
#' @importFrom dplyr all_of mutate
#' @importFrom magrittr "%$%"

pplots <- function(simdat, alpha){

  simdat <- as.data.frame(simdat)

  simdat <- as.data.frame(simdat)

  simdat_long <- tidyr::gather(simdat, "condition", "pval", all_of("ps.hack"):all_of("ps.orig"))

  bin <- condition <- Freq <- binInt <- pval <- plotVal <- NULL

  plotdata <-
    simdat_long %>%
    mutate(bin = cut(pval, seq(0, 1, by=0.025))) %$%
    table(bin, condition) %>%
    as.data.frame() %>%
    mutate(plotVal = ifelse(condition == "ps.orig",
                            -1*Freq,
                            Freq)) %>%
    mutate(binInt = as.integer(bin))


  pcomp <- ggplot(plotdata,
                  aes(x = binInt,
                      y = plotVal,
                      fill = condition)) +
    geom_segment(x = 0.5, xend = 40.5, y = nrow(simdat)/40, yend = nrow(simdat)/40, color = "#C27516") +
    geom_segment(x = 0.5, xend = 40.5, y = -nrow(simdat)/40, yend = -nrow(simdat)/40, color = "#024B7A") +
    geom_col() +
    scale_x_continuous(breaks = c(c(0, 10, 20, 30, 40)+0.5, alpha*40+0.5),
                       labels = c("0", "0.25", "0.5", "0.75", "1", expression(alpha))) +
    scale_y_continuous(breaks = waiver(),
                       labels = abs) +
    xlab("p-value") +
    ylab("count") +
    ggtitle("Distribution of p-values") +
    scale_fill_manual(values=c("#FFAE4A", "#43B7C2"),
                      labels=c("p-hacked", "original")) +
    theme_light() +
    theme(axis.title = element_text(size=14),
          axis.text = element_text(size=12),
          plot.title = element_text(size=18)) +
    geom_vline(xintercept = alpha*40+0.5, linetype = "dashed")

  return(list(pcomp=pcomp))
}

#' Plot effect size distributions
#' @param simdat Simulated data from one of the p-hacking simulation functions
#' @param EScolumn.hack Column number of hacked effect sizes
#' @param EScolumn.orig Column number of original effect sizes
#' @param titles Title of effect size plots
#' @importFrom grid grobTree textGrob gpar
#' @importFrom ggplot2 annotation_custom coord_cartesian

esplots <- function(simdat, EScolumn.hack, EScolumn.orig, titles = c(expression("Distribution of p-hacked effect sizes R"^2),
                                                                           expression("Distribution of original effect sizes R"^2))){

  simdat <- as.data.frame(simdat)
  es.hack <- colnames(simdat)[EScolumn.hack]
  es.orig <- colnames(simdat)[EScolumn.orig]

  meanES.hack <- grobTree(textGrob(paste0("Mean: ", round(mean(simdat[,es.hack]), 3)), x = 0.95, y=0.95, hjust=1, gp=gpar(fontsize=14)))
  meanES.orig <- grobTree(textGrob(paste0("Mean: ", round(mean(simdat[,es.orig]), 3)), x = 0.95, y=0.95, hjust=1, gp=gpar(fontsize=14)))

  eshack <- ggplot(simdat, aes(x=simdat[,es.hack])) +
    geom_histogram(fill="#FFAE4A", color="#C27516", bins=30, na.rm=FALSE) +
    theme_light() +
    xlab("Effect Size") +
    ggtitle(titles[1]) +
    theme(axis.title = element_text(size=14),
          axis.text = element_text(size=12),
          plot.title = element_text(size=18)) +
    annotation_custom(meanES.hack)

  esnohack <- ggplot(simdat, aes(x=simdat[, es.orig])) +
    geom_histogram(fill="#43B7C2", color="#024B7A", bins=30) +
    theme_light() +
    xlab("Effect Size") +
    ggtitle(titles[2]) +
    theme(axis.title = element_text(size=14),
          axis.text = element_text(size=12),
          plot.title = element_text(size=18)) +
    annotation_custom(meanES.orig)

  xlim <- range(c(layer_scales(eshack)$x$range$range, layer_scales(esnohack)$x$range$range))

  eshack <- eshack + coord_cartesian(xlim = xlim)
  esnohack <- esnohack + coord_cartesian(xlim = xlim)

  return(list(eshack=eshack,
              esnohack=esnohack))

}








