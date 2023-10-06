import json
import logging as log
from pathlib import Path

import tweepy

with Path("token.json").open() as f:
    token = json.load(f)

client = tweepy.Client(
    consumer_key=token["api_key"],
    consumer_secret=token["api_key_secret"],
    access_token=token["access_token"],
    access_token_secret=token["access_token_secret"],
)

query = "bayern OR wahl has:geo lang:de"
tweets = client.search_recent_tweets(query=query, tweet_fields=["context_annotations", "created_at"], max_results=2)

for tweet in tweets.data:
    log.info(tweet.text)
    if len(tweet.context_annotations) > 0:
        log.info(tweet.context_annotations)
