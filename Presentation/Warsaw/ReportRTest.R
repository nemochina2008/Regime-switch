library(ReporteRs)
mydoc <- pptx()
slide.layouts(mydoc)
mydoc <- addSlide(mydoc, "Two Content")
mydoc <- addTitle(mydoc, "First ten lines of iris")
mydoc <- addFlexTable(mydoc, FlexTable(iris[1:10,]))
mydoc <- addParagraph(mydoc, value = c("", "Hello World"))
mydoc <- addSlide(mydoc, "Title and Content")                      
mydoc <- addPlot(mydoc, function() barplot(1:8, col = 1:8))
writeDoc(mydoc, "Presentation/Warsaw/Test.pptx")
