

#------------------------------------------------------------
# User's input parameters
#------------------------------------------------------------
print('Step1_Start')
dirIn                  <- "/addData2/03.FCdb/05.Selection/kkknnnkkk"
dirOut                 <- "/addData2/03.FCdb/06.RESULT"
normMethod             <- "MAS5"
print('Step1_completed')
#------------------------------------------------------------

args = c(dirIn, dirOut, normMethod)

# library
print('Step2_Start')
#source("http://bioconductor.org/biocLite.R")
#biocLite("affy")
library(affy)
print('Step2_completed')

#------------------------------------------------------------
# Get the absolute paths of input and output directories,
# in case they are inputted in relative paths.
#------------------------------------------------------------
#dirRun <- getwd()
print('Step3_Start')
#dirIn <- getwd()
print('Step3_completed')


print('Step4_Start')
if(!file.exists(dirOut))
  dir.create(dirOut)
setwd(dirOut)
dirOut <- getwd()
print('Step4_completed')


#------------------------------------------------------------
# Save command-line arguments and warning message to file.
#------------------------------------------------------------
setwd(dirOut)

# For command-line arguments
print('Step5_Start')
if(file.exists("arguments.txt")==T)
  unlink("arguments.txt")
for(i in 1:length(args))
{
  foutArgs <- "arguments.txt"
  cat(args[i], file=foutArgs, append=T, sep="\n")
}



# For warning message
options(warn=1)
foutWarningMessage <- file("warning_message.txt", open="wt")
sink(foutWarningMessage, type="message")
print('Step5_completed')

#------------------------------------------------------------
# Output file name
print('Step6_Start')
fOutQCreport <- "Affy_QC_report.pdf"
fOutNorm     <- "norm_affy.txt"
fOutboxPlot  <- "Boxplot_affy.pdf"
fOutMAplot   <- "MAplot.pdf"
print('Step6_completed')



# Reading input files
print('Step7_start')
cat("Reading input files", "\n", sep="")
setwd(dirIn)
finList      <- list.celfiles()
affyData     <- ReadAffy()

# QC report
cat("Processing QC report", "\n", sep="")
setwd(dirOut)
# QCReport (affyData, fOutQCreport)


# Normalization
cat("Doing normalization", "\n", sep="")
if(normMethod == "RMA"  ) normalizedExprs <- rma (affyData)
if(normMethod == "MAS5" ) normalizedExprs <- mas5(affyData)
if(normMethod == "dChip") 
{ 
  normalizedExprs <- expresso(affyData, normalize.method="invariantse",
                              bg.correct = F, pmcorrect.method = "pmonly",
                              summary.method = "liwong")
}
exprsMtrx   <- exprs(normalizedExprs)
print('Step7_completed')


# Writing the normalized data
print('Step8_start')
cat("Writing the output", "\n", sep="")
probeIDs    <- rownames  (exprsMtrx)
normOutTbl  <- data.frame(probeIDs, exprsMtrx)
write.table (normOutTbl , fOutNorm, sep="\t", row.names=F)
print('Step8_completed')



# Delete warning message file if there was no warning
print('Thelaststep_start')
setwd(dirOut)
if(file.info("warning_message.txt")$size == 0)
  unlink("warning_message.txt")
print('AllSteps_completed')
