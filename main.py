# twitter data using scare
import snscrape.modules.twitter as sntwitter
import pandas as pd

query = "Nate Diaz min_faves:1 lang:en since:2023-04-05"

for tweet in sntwitter.TwitterSearchScraper(query).get_items():
    print(vars(tweet))
    break

limit = 10000
tweets = []

for tweet in sntwitter.TwitterSearchScraper(query).get_items():
    if len(tweets) == limit:
        break
    else:
        tweets.append([tweet.date, tweet.user.username, tweet.content])


df = pd.DataFrame(tweets, columns=['date', 'user', 'tweet'])
print(df)

df.to_csv('tweets.csv', index=False, encoding='utf-8')
df.to_json('tweets.json', orient='records', lines=True)




