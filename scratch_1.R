# Load the libraries
library(dplyr)
library(readr)
library(tidyr)
library(lubridate)

# Read in the data
tweets <- read_csv("tweets.csv")
# Inspect the first six rows
head(tweets)

# Count the nubmer of tweets by source
tweets %>% count(User, sort = TRUE)

# Clean the tweets
cleaned_tweets <- tweets %>%
  select(Date, User, Tweet)

# Inspect the first six rows
head(cleaned_tweets)


# Load the tidytext package
library(tidytext)

# Create a regex pattern
reg <- "([^A-Za-z\\d#@']|'(?![A-Za-z\\d#@]))"

# Unnest the text strings into a data frame of words
tweet_words <- cleaned_tweets %>%
  unnest_tokens(word, Tweet, token = "regex", pattern = reg)

# Inspect the first six rows of tweet_words
head(tweet_words)

# Plot the most common words from @realDonaldTrump tweets
tweet_words %>%
  count(word, sort = TRUE) %>%
  head(20) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_bar(stat = "identity") +
  ylab("Occurrences") +
  coord_flip()

# Load the tidytext package
library(tidytext)

# get nrc lexicon
nrc <- get_sentiments("nrc")


# Join the NRC lexicon to tweet words
tweet_sentiments <- tweet_words %>%
  inner_join(nrc, by = "word")

# Inspect the first six rows
head(tweet_sentiments)

# plot the most common words for each sentiment and make the word counts appear on the plot
tweet_sentiments %>%
  count(word, sentiment, sort = TRUE) %>%
  group_by(sentiment) %>%
  top_n(5) %>%
  ungroup() %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  coord_flip()

# plot the sentiments on a bar chart
tweet_sentiments %>%
  count(sentiment, sort = TRUE) %>%
  ggplot(aes(sentiment, n)) +
  geom_bar(stat = "identity") +
  ylab("Occurrences") +
  coord_flip()


# save the main data frame to a csv file
write.csv(tweet_sentiments, "main_words.csv")


