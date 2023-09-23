# Mastodon  - Election Predictions

## Task

Analyse the mastodon toots about the bavarian election on Oct, 8th 2023. Appling a sentiment analysis on the toots. Differentiate region.

## Background

Mastodon is a micro blogging service, that is federated and part of the fediverse. Depending on the source Mastodon 8.1 M users world wide ([fedidb](https://fedidb.org/)),  or 13.8 M users (@mastodonusercount@mastodon.social) on 08/06/2023.



Mastodon has a relative high number regional servers. A high number are German. 

## Monitored Parties

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

## Polls

Tolls from different sources are listed at [wahlrecht.de]([Wahlumfragen zur Landtagswahl 2023 in Bayern (Sonntagsfrage #ltwby)](https://www.wahlrecht.de/umfragen/landtage/bayern.htm#fn-bp)). The time lime for each party for the 

The strongest party loses percentages in the last year.

![](./graphics/visualization_csu_polls.svg)

While its coalition partner increases by a similar perentage.

![](./graphics/visualization_fw_polls.svg)

The most polular oppostion parties show a trend of loosing lefts and gaining ultra right.

![](./graphics/visualization_gruene_polls.svg)
![](./graphics/visualization_afd_polls.svg)

## Population in Germany

Germany has slitly more woman (50.5 %) than man [Bevölkerungsstand: Amtliche Einwohnerzahl Deutschlands 2022 - Statistisches Bundesamt](https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Bevoelkerungsstand/_inhalt.html) . This is due to the age distrution of its citizen [population pyramide]([Bevölkerungspyramide: Altersstruktur Deutschlands von 1950 - 2060](https://service.destatis.de/bevoelkerungspyramide/index.html#!y=2023)) Because man have a higher mortability rate at higher ages. 



## Approach

Following tags are monitored on the instance *chaos.social* by the topics:

- Bavaria: bayern bayernwahl bayernwahl2023 

- Election: wahlen wahlkampf wahlumfrage wahlen23 wahlen2023 

- Parties: spd csu gruene  grune gruenen grunen afd freiewaehler freiewahler fw fpd linke 

- Candidates: markussoeder markussoder soeder soder hubertaiwanger aiwanger hartmann martinhagen ebnersteiner

Some candidates were not included in the tag search, because the tags where not in used at the beginning of the study.



A wide set of topics have been selected to retrieve a maximum of taged posts. Throw the federation of instances, it is possible that not all instances share posts, or not all posts. Still only a single instance have been monitored, so that 



Search of posts without the need of tags, have been added during the monitoring with Mastodon version 4.2.  Developmentis done on the instance *mastodon.social*, when other instane follow, a stable release is up to there administration. Search without tags might retrieve addition posts.

The posts have been retrieve via the api:***instance_url/api/v1/timelines/tag/#{tag}*** Which is done without a login, therefore only public posts are monitored.



The api is requested every full hour starting 08/29/23 non stop on a raspberry pi. First data have been inserted 08/28/23. The monitoring is done with a Elixir programm that runs on Erlang's BEAM runtime. To increase stabiliy. Therefore each post is written for into four tables of a SQLite3 database. The toots table contains the post itself and some of its user data. The users table contains some data of the posts about the users, that wrote the posts.

The  related table fields contains the fields a user can set, to contain some information about him-/herself. The related tags table contains all tags of every post.



The evaluation is done in a Elixir Livebook.

The posts are first filtered to contain any of the candidate names or the name Bavaria, or the party name CSU, as it is a regional party. The other parties are eligible nationwide. Than the special characters and html mark-ups are removed. The posts are filtered whether only a single party is mentioned.

The posts also contain a language lable, but this is set by the user or his/her application and is errorprone. Therefore, the language is detected by the model [***papluca/xlm-roberta-base-language-detection***]([papluca/xlm-roberta-base-language-detection · Hugging Face](https://huggingface.co/papluca/xlm-roberta-base-language-detection)).  The model is included in the Livebook smart cells.

The german sentiment analysis is done with the model [***oliverguhr/german-sentiment-bert***]([oliverguhr/german-sentiment-bert · Hugging Face](https://huggingface.co/oliverguhr/german-sentiment-bert)). The model is a python package. Therefore an attempt to use is in Elixir has been done with ONNX. The problem was the correct setting of the tokenizer (bert-base-german-cased). Therefore it was much simpler to use the Elixir library Bumblebee, that makes both useable with less code. The python code that generated the onnx file and the vocab.json is included.

The few English language posts are evaluated with the model [***finiteautomata/bertweet-base-sentiment-analysis***]([finiteautomata/bertweet-base-sentiment-analysis · Hugging Face](https://huggingface.co/finiteautomata/bertweet-base-sentiment-analysis)). 

The remaining posts are selected into the three groups, Bavarian, German, English.

For the porpuse of this project, following Mastodon instances are estimated to be used by bavarian users (only):

- muenchen.social

- augsburg.social

- mastodon.bayern

- nuernberg.social

- ploen.social

- wue.social (Würzburg)

- mastodon.dachgau.social

- sueden.social (hypothesis: low difference to other southern regions)

In addition the fields and notes of each user are scanned for Bavarian location names. 

As final seperation the gender of each user is estimated by:

1) name

2) user note text 

3) user fields

4) user picture?



b) get age distribution??? From text, from user image?



## Linklist

### Fediverse

- [fedidb](https://fedidb.org/)
- [OSM - Mastodon server](https://umap.openstreetmap.fr/en/map/mastodon-near-me-global-mastodon-server-list-by-co_828094)
- [Mastodon Python API](https://mastodonpy.readthedocs.io/en/stable/07_timelines.html)
  
  

### Twitter

- [APIs](https://developer.twitter.com/en/docs/twitter-api/tools-and-libraries/v2)

### 

### Umfragen

[Sonntagsfrage – Umfragen Landtagswahlen (Wahlumfrage, Wahlumfragen)](https://www.wahlrecht.de/umfragen/landtage/)
