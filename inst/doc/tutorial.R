## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
options(rmarkdown.html_vignette.check_title = FALSE)

## ----warning=FALSE,message=FALSE----------------------------------------------
library(rankrate)
library(reshape2) # data reformatting
library(pander)   # creating nice tables
library(ggplot2)  # creating nice figures

## -----------------------------------------------------------------------------
data("ToyData3")

## ----warning=FALSE, fig.asp = 0.7, out.width="90%",dpi=300--------------------
rankings_table <- as.data.frame(ToyData3$rankings)
rownames(rankings_table) <- paste0("Judge ",1:16)
names(rankings_table) <- paste0("Rank ",1:3)
pander(rankings_table)
rankings_long <- melt(ToyData3$rankings)
names(rankings_long) <- c("Judge","Rank","Proposal")
ggplot(rankings_long,aes(x=Proposal,fill=factor(Rank)))+theme_bw(base_size=10)+
  geom_bar()+scale_fill_manual(values=c("#31A354","#A1D99B","#E5F5E0"))+
  labs(fill="Rank",y="Count")+ggtitle("Ranks by Proposal")+
  theme(panel.grid = element_blank())

## ----warning=FALSE, fig.asp = 0.7, out.width="90%",dpi=300--------------------
ratings_table <- as.data.frame(ToyData3$ratings)
rownames(ratings_table) <- paste0("Judge ",1:16)
names(ratings_table) <- c("Proposal: 1",2:3)
set.alignment("right")
pander(ratings_table)
ratings_long <- melt(ToyData3$ratings)
names(ratings_long) <- c("Judge","Proposal","Rating")
ggplot(ratings_long,aes(x=factor(Proposal),y=Rating))+theme_bw(base_size=10)+
  geom_boxplot(color="gray")+geom_jitter(height=0,width=0.4,alpha=0.75)+
  labs(x="Proposal",y="Rating")+ggtitle("Ratings by Proposal")+
  theme(panel.grid = element_blank())

## -----------------------------------------------------------------------------
MLE_mb <- fit_mb(rankings=ToyData3$rankings,ratings=ToyData3$ratings,M=ToyData3$M,method="ASTAR")
pander(data.frame(Parameter=c("Consensus Ranking, pi_0",
                       "Object Quality Parameter, p",
                       "Consensus Scale Parameter, theta"),
           MLE=c(paste0(MLE_mb$pi0,collapse="<"),
                 paste0("(",paste0(round(MLE_mb$p,2),collapse=","),")"),
                 round(MLE_mb$theta,2))))

## ---- fig.asp = 0.7, out.width="90%",dpi=300----------------------------------
CI_mb <- ci_mb(rankings=ToyData3$rankings,ratings=ToyData3$ratings,M=ToyData3$M,
               interval=0.95,nsamples=200,method="ASTAR")
plot_p <- as.data.frame(cbind(1:3,MLE_mb$p,t(CI_mb$ci[,1:3])))
names(plot_p) <- c("Proposal","PointEstimate","Lower","Upper")
ggplot(plot_p,aes(x=Proposal,y=PointEstimate,ymin=Lower,ymax=Upper))+
  geom_point()+geom_errorbar()+ylim(c(0,1))+theme_bw(base_size=10)+
  labs(x="Proposal",y="Estimated Quality (95% CI)")+
  ggtitle("Estimated Quality by Object")+
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank())
plot_pi0 <- as.data.frame(cbind(1:3,order(MLE_mb$pi0),t(CI_mb$ci_ranks)))
names(plot_pi0) <- c("Proposal","PointEstimate","Lower","Upper")
ggplot(plot_pi0,aes(x=Proposal,y=PointEstimate,ymin=Lower,ymax=Upper))+
  geom_point()+geom_errorbar()+theme_bw(base_size=10)+
  scale_y_continuous(breaks=1:3)+
  labs(x="Proposal",y="Estimated Rank (95% CI)")+
  ggtitle("Estimated Rank by Object")+
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank())

