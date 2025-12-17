#install packages
install.packages("pdftools")
install.packages("tm")
install.packages("SnowballC")
install.packages("wordcloud")
install.packages("RColorBrewer")

#load packages
library(pdftools)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)

pdf_file <- "epsteinFilesTransparencyAct.pdf"

#extract text from PDF
pdf_text_vec <- pdf_text(pdf_file)

#collapse into string
text <- paste(pdf_text_vec, collapse = " ")

#create corpus from text
docs <- Corpus(VectorSource(text))

toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, stripWhitespace)

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
word_freq <- sort(rowSums(m), decreasing = TRUE)
df <- data.frame(word = names(word_freq), freq = word_freq)

#actual cloud
set.seed(1234)
wordcloud(words = df$word,
          freq = df$freq,
          min.freq = 3,
          max.words = 150,
          random.order = FALSE,
          rot.per = 0.35,
          colors = brewer.pal(8, "Dark2"))