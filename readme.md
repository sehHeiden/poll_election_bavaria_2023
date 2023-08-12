# Mastodon  - Election Predictions

## Task

Analyse the mastodon toots about the bavarian election on Oct, 8th 2023. Appling a sentiment analysis on the toots. Differentiate region by Mastodon instance.

Perhaps also by language features? Trying to differentiat by age.

## Background

Mastodon is a micro blogging service, that is federated and part of the fediverse. Depending on the source Mastodon 8.1 M users world wide ([fedidb](https://fedidb.org/)),  or 13.8 M users (@mastodonusercount@mastodon.social) on 08/06/2023.

Mastodon has a relative high number regional servers. A high number are German. 

For the porpuse of this project, following Mastodon instances are estimated to be used by bavarian users (only):

- muenchen.social

- augsburg.social

- mastodon.bayern

- nuernberg.social

- ploen.social

- wue.social (Würzburg)

- mastodon.dachgau.social

- sueden.social (hypothesis: low difference of other southern regions)

There are more German instances, that are multilingual or have a special base topic. Hence,  I will try do differentiate 

1) Which users on others servers are bavarian (is this possible by speech analysis?)

2) Try to estimate how, Germany in whole would elect differently.

3) Differentiate the peer groups (by computervision, text analysis)?

## Parties

The sentiment for the following parties will be watched (sorted from left to right):

| Party                     | Candidate(s)                        | Percentage 2018 |
| ------------------------- | ----------------------------------- | --------------- |
| Linke                     | Adelheid Rupp                       | 3.2             |
| SPD                       | Florian von Brunn                   | 9.7             |
| Grüne                     | Ludwig Hartmann & Katharina Schulze | 17.6            |
| FDP                       | Martin Hagen                        | 5.1             |
| CSU (Baverian only party) | Markus Söder                        | 37.2            |
| Freie Wähler              | Hubert Aiwanger                     | 11.6            |
| AfD                       | Katrin Ebner-Steiner & Martin Böhm  | 10.2            |

Source: [Landtagswahl in Bayern 2023: Kandidaten, Themen, Termin | BR24](https://www.br.de/nachrichten/bayern/landtagswahl-in-bayern-2023-termin-themen-kandidaten,TMD4uSM)

[Bayerische Linke kürt Adelheid Rupp als Spitzenkandidatin | BR24](https://www.br.de/nachrichten/bayern/bayerische-linke-kuert-adelheid-rupp-als-spitzenkandidatin,TZXl5yd)


The strongest party loses percentages in the last year.
![](/home/sebastianh/Dokumente/Basti/Studium/HSHarz/Praxisprojekt/poll_election_bavaria_2023/graphics/visualization_csu_polls.svg)
While its coalition partner increases by a similar perentage.
![](/home/sebastianh/Dokumente/Basti/Studium/HSHarz/Praxisprojekt/poll_election_bavaria_2023/graphics/visualization_fw_polls.svg)

The most polular oppostion parties show a trend of loosing lefts and gaining ultra right.
![](/home/sebastianh/Dokumente/Basti/Studium/HSHarz/Praxisprojekt/poll_election_bavaria_2023/graphics/visualization_grune_polls.svg)
![](/home/sebastianh/Dokumente/Basti/Studium/HSHarz/Praxisprojekt/poll_election_bavaria_2023/graphics/visualization_afd_polls.svg)

## Linklist

### Fediverse

- [fedidb](https://fedidb.org/)
- [OSM - Mastodon server](https://umap.openstreetmap.fr/en/map/mastodon-near-me-global-mastodon-server-list-by-co_828094)
- [Mastodon Python API](https://mastodonpy.readthedocs.io/en/stable/07_timelines.html)
- [Elixir: MastodonClient — mastodon_client v0.1.0](https://hexdocs.pm/mastodon_client/readme.html#usage)
- [Elixir: ueberauth_mastodon — ueberauth_mastodon v0.2.1](https://hexdocs.pm/ueberauth_mastodon/readme.html)
- [Mastodon Example](https://www.sothawo.com/post/2023/05/07/download-the-list-of-followers-from-your-mastodon-account/)

### Twitter

- [APIs](https://developer.twitter.com/en/docs/twitter-api/tools-and-libraries/v2)

### NLP - Sentiment

https://spacy.io/universe/project/spacy-sentiws

https://www.nltk.org/book/ch01.html

https://medium.com/@michael.zats/effortless-sentiment-analysis-in-german-language-with-python-d870798acd9d

https://github.com/oliverguhr/german-sentiment-lib
[oliverguhr/german-sentiment-bert · Hugging Face](https://huggingface.co/oliverguhr/german-sentiment-bert)     

https://github.com/adbar/German-NLP

https://machine-learning-blog.de/2019/06/03/stimmungsanalyse-sentiment-analysis-auf-deutsch-mit-python/

### Umfragen

[Sonntagsfrage – Umfragen Landtagswahlen (Wahlumfrage, Wahlumfragen)](https://www.wahlrecht.de/umfragen/landtage/)
