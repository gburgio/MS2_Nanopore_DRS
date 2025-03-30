
library("Deseq2")
library("ggplot2")
library("RColorBrewer")

#loading and check data
#quantification_MS2_new_phage_total.txt is the read count matrix
# MS2_metadata_phage.txt is the metadata 

quantification_MS2_new_phage_total <- read.delim("~/quantification_MS2_new_phage_total.txt", row.names=1)
View(quantification_MS2_new_phage_total)
MS2_metadata_phage <- read.delim("~/MS2_metadata_phage.txt", row.names=1)
View(MS2_metadata_phage)
all(colnames(quantification_MS2_new_phage_total) %in% row.names(MS2_metadata_phage))
ncol(quantification_MS2_new_phage_total) == nrow(MS2_metadata_phage)

#Deseq2 matrix
dds <- DESeqDataSetFromMatrix(countData=quantification_MS2_new_phage_total, colData=MS2_metadata_phage,design=~time)
dds <- estimateSizeFactors(dds)
normalized_counts <- counts(dds, normalized=TRUE)
write.table(normalized_counts, file="normalized_counts.txt", sep="\t", quote=F, col.names=NA)

#Deseq2 
dds <- DESeq(dds)
plotDispEsts(dds)
res <- results(dds)
resLFC <- lfcShrink(dds, coef="time_3h_vs_0h", type="apeglm")
resLFC <- lfcShrink(dds, coef="time_6h_vs_0h", type="apeglm")
plotMA(res, ylim=c(-2,2))
plotMA(resLFC, ylim=c(-2,2))

plotcount <- plotCounts(dds, gene=which.min(res$padj), intgroup="time", returnData = TRUE)
ggplot(plotcount, aes(x=time, y=count)) + geom_point(position=position_jitter(w=0.1,h=0)) + scale_y_log10(breaks=c(25,100,400))
resOrdered <- res[order(res$pvalue),]
write.csv(as.data.frame(resOrdered), file="condition_treated_results.csv")

#heat map
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(vsd$time, vsd$type, sep="-")
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix, clustering_distance_rows=sampleDists, clustering_distance_cols=sampleDists, col=colors)

#PCA
pcaData <- plotPCA(vsd, intgroup=c("condition"), returnData=TRUE)
pcaData <- plotPCA(vsd, intgroup=c("time"), returnData=TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))

#plot individual ORFs
par(mfrow=c(2,3))
plotCounts(dds, gene="mat", intgroup="time")
plotCounts(dds, gene="cap", intgroup="time")
plotCounts(dds, gene="lys", intgroup="time")
plotCounts(dds, gene="rep", intgroup="time")


