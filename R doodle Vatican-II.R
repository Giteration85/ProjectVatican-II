#importing datasets and finding out smallest one (fewest variables) so as to start variable selection there

install.packages("readxl")
library(readxl)
#https://www.switchingtomac.com/tutorials/osx/5-ways-to-reveal-the-path-of-a-file-on-macos/
#most helpful way to find pathname was via Terminal, dragging and dropping a file onto it, then copying and pasting, and deleting "\" chars
VatII40 <- read_xlsx("/Users/james.creznic/Documents/GitHub/ProjectVatican-II/System For Catholic Research, Information and Planning (1940), 1990.XLSX")
VatII50 <- read_xlsx("/Users/james.creznic/Documents/GitHub/ProjectVatican-II/System For Catholic Research, Information and Planning (1950), 1990.XLSX")
VatII60 <- read_xls("/Users/james.creznic/Documents/GitHub/ProjectVatican-II/System For Catholic Research, Information and Planning (1960), 1990.XLS")
VatII70 <- read_xlsx("/Users/james.creznic/Documents/GitHub/ProjectVatican-II/System For Catholic Research, Information and Planning (1970), 1990.XLSX")
VatII80 <- read_xlsx("/Users/james.creznic/Documents/GitHub/ProjectVatican-II/System For Catholic Research, Information and Planning (1980), 1990.XLSX")
VatII90 <- read_xls("/Users/james.creznic/Documents/GitHub/ProjectVatican-II/System For Catholic Research, Information and Planning (1990), 1990.XLS")

a<-ncol(VatII40)
b<-ncol(VatII50)
c<-ncol(VatII60)
d<-ncol(VatII70)
e<-ncol(VatII80)
f<-ncol(VatII90)
sets <- c(a,b,c,d,e,f)
which.min(sets[-6]) #omitting 1990s data
c #found it, 1960s
# so we start here for variable selection
