# Mastodon  - Election Predictions

## Introduction and Objectives

[Mastodon]([Annual Report 2022 - Mastodon Blog](https://blog.joinmastodon.org/2023/10/annual-report-2022/)) is a micro blogging service, that is federated and part of the fediverse. Depending on the source Mastodon 8.3 M users world wide ([fedidb](https://fedidb.org/)),  or 14.1 M users (@mastodonusercount@mastodon.social) on 24/09/2023. Because many services are able to federate with each other, it is possible to read data from other serveres as Misskey, Lemmy, Pixelfed and so on. Even some Wordpress-Blogs can be read.

Mastodon has a relative high number regional servers (see [OSM - Mastodon server](https://umap.openstreetmap.fr/en/map/mastodon-near-me-global-mastodon-server-list-by-co_828094)). A high number are German.  Mastodon had a strong spike in usage in November 2022 with 2.5 M monthly recurrent users. Currently the network has still [1.4 mio]([Servers - Mastodon](https://joinmastodon.org/servers)) monthly recurrent users.

Beside Mastodon, [X](https://developer.twitter.com/en/docs/twitter-api) was also investigated as possible source. But was to expensive for a research project. We will use the terms posts and toots interchangebly.

We analyse Mastodon toots about the bavarian election on Oct, 8th 2023. Therefore we apply a sentiment analysis. We atempt to differentiate regions and gender.

### Monitored Parties

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

### Polls

Tolls from different sources are listed at [wahlrecht.de]([Wahlumfragen zur Landtagswahl 2023 in Bayern (Sonntagsfrage #ltwby)](https://www.wahlrecht.de/umfragen/landtage/bayern.htm#fn-bp)). The time lime for each party for the 

The strongest party `CSU` loses percentages in the last year.

![](./graphics/visualization_csu_polls.svg)

While its coalition partner `Freie Waehler` increases by a similar perentage.

![](./graphics/visualization_fw_polls.svg)

Oppostion parties as  show a trend of loosing on the lefts spectrum and gaining in the ultra right spectrum (`AFD`).

![](./graphics/visualization_gruene_polls.svg)
![](./graphics/visualization_afd_polls.svg)

## Population in Germany

Germany has slitly more woman (50.5 %) than man [Bevölkerungsstand: Amtliche Einwohnerzahl Deutschlands 2022 - Statistisches Bundesamt](https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Bevoelkerungsstand/_inhalt.html). This is due to the age distrution of its citizen [population pyramide, because man have a higher mortability rate at higher ages.  

## Methods

### Monitoring

Following tags are monitored on the instance *chaos.social* by the topics:

- Bavaria: bayern bayernwahl bayernwahl2023 

- Election: wahlen wahlkampf wahlumfrage wahlen23 wahlen2023 

- Parties: spd csu gruene  grune gruenen grunen afd freiewaehler freiewahler fw fpd linke 

- Candidates: markussoeder markussoder soeder soder hubertaiwanger aiwanger hartmann martinhagen ebnersteiner

Some candidates were not included, because their tags where not in used at the beginning of the study.

A wide set of topics have been selected to retrieve a maximum of taged posts. Due to the concept of federation of instances, it is possible that not all instances share posts, or not all posts. Still only a single instance have been monitored. To reduce the need of removing doublicates with different ids on each instance. 

Search of posts without the need of tags, has been released during the monitoring with Mastodon version 4.2 in the end of September 2023.  It was added on October 3rd on chaos.social. Reindexing stated have been finished on October 5th. The search was added on October 7th to the monitoring.

We retrieve the tags via the public timeline of the isntance and the search via the seach api

* ***instance_url/api/v1/timelines/tag/{tag_name}*** 

* ***isntance_url/api/v2/search?q={search_word}***

The search in the public timeline is done without a login, therefore only public posts are monitored. For the search a bearer token is neaded. During the addition of the search the limit of requested post was increased from 20 (default) to 40 (maximum).

The api is requested every full hour starting 08/29/23 on a raspberry pi. First data has been inserted on 08/28/23. The monitoring is done with a Elixir programm that runs on Erlang's BEAM runtime. To increase stabiliy. For instance automatic recovering after failing connections. Each post is written into four tables of a SQLite3 database. The toots table contains the post itself and some of its user data. The users table contains some data of the posts about the users, who wrote the posts.

The related table fields contains the fields a user can set, to add some information about him-/herself. The related tags table contains all tags of every post.

### Data Analysis

#### Data Preparation

The evaluation is done in an [Elixir Livebook](election_bavaria.livemd). First Exploration was done on a split off of the dataset, which was recored until 09/10/23. About 12 days of full records. This dataset was used to fine tune the analysis. 

First we tried to filter only Bavaria specific posts and remove posts, that are off topic, or might contain federal topic or the other electon in Hessia But analysis showed, that most mentioned the parties AFD, CSU and FW. Less than 4 % mentioned the Parties FDP, Grune, or Linke. This effect was even enhanced after filtering via the candidate names, the state name Bayern, or CSU and after removing all posts than mention zero or more than one party. Filtering was so strong, that for these parties only a hand full of posts each remained. Because the candidates are less known, and over shadowed by national discussion about their party. On the other side, the where nation wide discussion about the local candidates ofd the CSU and FW. Which increased there share.  

**TODO Planning: Therefore, we added:**

We cleared html tags, links and the characters #, @ and _ from the posts. The posts of non-zero length in the evaluation data set is 205 (median) and 235 +/- 190 (average  and standard deviation) characters. The maxium was over 5000 characters. 

#### Sentiment Analysis

The posts all contain a language lable, but this is set by the user or his/her application and is therefore errorprone. We detect the language by the model [***papluca/xlm-roberta-base-language-detection***]([papluca/xlm-roberta-base-language-detection · Hugging Face](https://huggingface.co/papluca/xlm-roberta-base-language-detection)) with a limit 0f 100 character. The model is included in the Livebook smart cells.

The german sentiment analysis is done with the model [***oliverguhr/german-sentiment-bert***]([oliverguhr/german-sentiment-bert · Hugging Face](https://huggingface.co/oliverguhr/german-sentiment-bert)). We limited the model to 425 of 512 possible characters (sum of average length and standard deviation). The model is a python package. Therefore we attempted to use is in Elixir via ONNX. The problem was the correct setting of the tokenizer (bert-base-german-cased). Therefore it was much simpler to use the Elixir library Bumblebee.

The few English language posts are evaluated with the model [***finiteautomata/bertweet-base-sentiment-analysis***]([finiteautomata/bertweet-base-sentiment-analysis · Hugging Face](https://huggingface.co/finiteautomata/bertweet-base-sentiment-analysis)) with the limit of 130 characters. 

**TODO:** The remaining posts are selected into the three groups, Bavarian, German, English.

#### Spatial Differentiation

Based on [OSM - Mastodon server](https://umap.openstreetmap.fr/en/map/mastodon-near-me-global-mastodon-server-list-by-co_828094) following Mastodon instances are estimated to be used by bavarian users:

- muenchen.social

- augsburg.social

- mastodon.bayern

- nuernberg.social

- ploen.social

- wue.social (Würzburg)

- mastodon.dachgau.social

- sueden.social

We added sueden.social based on the untested hypothesis, that the overall sentiment in southern Germany is similar the Bavarian. In addition the fields and notes of each user are scanned for Bavarian location names [OpenData Geodaten Bayern](https://geodaten.bayern.de/opengeodata/OpenDataDetail.html?pn=verwaltung).

As final seperation the gender of each user is estimated by:

1) name

2) user note text 

3) user fields

4) user picture?

#### Age and Gender Differtiation

Gender Classification with [Salesforce/blip-image-captioning-base · Hugging Face](https://huggingface.co/Salesforce/blip-image-captioning-base) that generates captions of images. The captions are scanned for man/woman.

**TODO Test:** [MiVOLO]([[2307.04616v2] MiVOLO: Multi-input Transformer for Age and Gender Estimation](https://arxiv.org/abs/2307.04616v2)), [onnx Gender and Age]( https://github.com/onnx/models/tree/main/vision/body_analysis/age_gender)

## Linklist

### Fediverse

- [fedidb](https://fedidb.org/)
- [OSM - Mastodon server](https://umap.openstreetmap.fr/en/map/mastodon-near-me-global-mastodon-server-list-by-co_828094)
- [Mastodon Python API](https://mastodonpy.readthedocs.io/en/stable/07_timelines.html)

### Umfragen

[Sonntagsfrage – Umfragen Landtagswahlen (Wahlumfrage, Wahlumfragen)](https://www.wahlrecht.de/umfragen/landtage/)

## Monitoring Interruptions

22 hours no update from 30.09. 22:00 to 01.10. 20:00.
