# Mastodon  - Election Predictions

## Introduction and Objectives

[Mastodon](https://blog.joinmastodon.org/2023/10/annual-report-2022/) is a micro blogging service, that is federated by the [ActivityPub](https://en.wikipedia.org/wiki/ActivityPub) protocol and part of the fediverse. Depending on the source Mastodon 8.4 M users world wide ([fedidb](https://fedidb.org/)),  or 14.4 M users (@mastodonusercount@mastodon.social) both on Oct. 10th 2023. Because many services are able to federate with each other, it is possible to read posts from other services as Misskey, Lemmy, Pixelfed and so on. Even some Wordpress-Blogs can be read.

Mastodon has a relative high number regional servers (see [OSM - Mastodon server](https://umap.openstreetmap.fr/en/map/mastodon-near-me-global-mastodon-server-list-by-co_828094)). A high number are German.  Mastodon had a strong spike in usage in Nov. 2022 with 2.5 M monthly recurrent users. Currently the network has still [1.7 mio](https://joinmastodon.org/servers) monthly recurrent users.

Beside Mastodon, [X](https://developer.twitter.com/en/docs/twitter-api) was also investigated as possible source. But was excluded for [monetary reasons](https://www.heise.de/news/API-Zugriff-nur-gegen-Geld-Ueber-100-Forschungsprojekte-zu-X-Twitter-gestoppt-9355078.html?wt_mc=sm.red.ho.mastodon.mastodon.md_beitraege.md_beitraege). We will use the terms posts and toots interchangebly.

We analyse Mastodon toots with the topic Bavaria state election which took place on Oct. 8th 2023. We apply a sentiment analysis. We atempt to differentiate regions.

### Monitored Parties

The sentiment for the following parties and parties were monitored (sorted from left to right):

| Party                     | Candidate(s)                        | Percentage 2018 | Percentage 2023 |
|:------------------------- |:----------------------------------- |:--------------- |:--------------- |
| Linke                     | Adelheid Rupp                       | 3.2             | 1.5             |
| SPD                       | Florian von Brunn                   | 9.7             | 8.4             |
| Grüne                     | Ludwig Hartmann & Katharina Schulze | 17.6            | 14.4            |
| FDP                       | Martin Hagen                        | 5.1             | 3.0             |
| CSU (Baverian only party) | Markus Söder                        | 37.2            | 37.0            |
| Freie Wähler              | Hubert Aiwanger                     | 11.6            | 15.8            |
| AfD                       | Katrin Ebner-Steiner & Martin Böhm  | 10.2            | 14.6            |

Source: [Landtagswahl in Bayern 2023: Kandidaten, Themen, Termin | BR24](https://www.br.de/nachrichten/bayern/landtagswahl-in-bayern-2023-termin-themen-kandidaten,TMD4uSM)

[Bayerische Linke kürt Adelheid Rupp als Spitzenkandidatin | BR24](https://www.br.de/nachrichten/bayern/bayerische-linke-kuert-adelheid-rupp-als-spitzenkandidatin,TZXl5yd)

## Population in Bavaria

Bavaria has about 13.3 mio inhabitants and slightly more woman (50.5 %) [Bevölkerung in den Gemeinden Bayerns nach Altersgruppen und Geschlecht](https://www.statistik.bayern.de/mam/produkte/veroffentlichungen/statistische_berichte/a1310c_202200.pdf). This is due to the age distribution of its citizen, because man have a higher mortability rate at higher ages. The peer group aged 40 to 50 is the first one with more than 50 % women. All younger peer groups show an surplus of men by two to five percent. On the other hand, the peer group of age 75 or older shows a surplus of women of about 17 %.

## Methods

### Monitoring

Following tags are monitored on the instance *chaos.social*. We group the tags by topics:

- Bavaria: bayern bayernwahl bayernwahl2023 
- Election: wahlen wahlkampf wahlumfrage wahlen23 wahlen2023 
- Parties: spd csu gruene  grune gruenen grunen afd freiewaehler freiewahler fw fpd linke 
- Candidates: markussoeder markussoder soeder soder hubertaiwanger aiwanger hartmann martinhagen ebnersteiner

Some candidates were not included, because their name were not used as tags at the beginning of the study. We only used German words as tags.

A wide set of topics have been selected to retrieve a maximum of taged posts. Due to the concept of federation of instances, it is possible that not all instances share posts, or not all posts. Still only a single instance have been monitored to reduce the need of removing doublicates with different ids on each instance. 

Search of posts without the need of tags, has been released during the monitoring with Mastodon version 4.2 in the end of Sep. 2023.  It was added on Oct. 3rd on chaos.social. Reindexing stated have been finished on Oct. 5th. The search was added on Oct. 7th to the monitoring.

We retrieve the tags via the public timeline of the instance and the search via the seach api

* ***instance_url/api/v1/timelines/tag/{tag_name}*** 
* ***isntance_url/api/v2/search?q={search_word}***

Search of tags in the public timeline is done without a login, therefore only public posts are monitored. For the search a bearer token is neaded. During the addition of the search the limit of requested post was increased from 20 (default) to 40 (maximum).

The posts are requested every full hour starting Aug. 29th 2023. The retrieval is done with a Elixir programm that runs on Erlang's BEAM runtime, to increase stabiliy. For instance automatic recovering after failing connections. Each post is written into four tables of a SQLite3 database. The `toots` table contains the post itself and some of its meta data. The `users` table contains some data of the posts about the users, who wrote the posts.

The related table `fields` contains the fields a user can set using key value pairs, to add some information about him-/herself. The related `tags` table contains all tags of each post.

Depending on the search term and how often it is used in posts, the time range of 20/40 vary. For some search terms, that are less frequent used, it lasts back several years. For other terms it ranges back several days only. This behaviour partially heals interruptions in the monitoring service. Or can be used to look back, when using very spefic search terms together with specifies as the use language.

### Data Analysis

#### Data Preparation

The evaluation is done in an [Elixir Livebook](election_bavaria.livemd). First exploration was done on a sub-sample of the dataset, which was recorded until Sep. 10th 2023. About 12 days of full records. This dataset was used to fine tune the analysis. This notebook is than applied on the full sample.
The texts are cleaned the texts to exclude:

- Html tags.
- Links.
- Characters: #, @ and _ .
- Removed double spaces.

The decision whether a post can be used for further Analysis is done by filtering in three stages:

1) Cleaned text contains more than 50 characters of cleaned text.
2) Keep only posts specific to Bavaria.
3) Keep only posts that is attributable a single/dominant party.

#### Regional Filter

The regional filter accepts any post that abides to any of the the three rules

1) Post must name of any local entity
2) Post must name of any candidate
3) Post must name csu (single regional party)

We use 3890 local entities from the state name down to village names. We do not use the 7860 sub-district names, as they amount is much higher as and includes some major common german words (e.g. Gern, Oder). Is also partialy true for villages names, (e.g. Wald). This filter method, may also keep posts which mention similar names, in other regions of the world.

### Attribute Sentiment to Party

To select posts, thats sentiment can me attributed to a party we test two methods:

1) Keep posts, that only name a single party, or their candidate(s).
2) Keep posts, that contains a dominant party, that is mentioned more often than, all other party combined.

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

We added sueden.social based on the untested hypothesis, that the overall sentiment in southern Germany is similar to Bavaria. In addition the fields and notes of each user are scanned for Bavarian location names [OpenData Geodaten Bayern](https://geodaten.bayern.de/opengeodata/OpenDataDetail.html?pn=verwaltung) from the state name to village name.

Following keys are used for the user fields:

- "adresse",
- "born where",
- "bundesland",
- "city",
- "country",
- "heimat",
- "heimathafen",
- "heimatort",
- "herkunft",
- "home",
- "location",
- "ort",
- "standort",
- "wahlkreis",
- "wo",
- "wohnhaft",
- "wohnort",
- "wohnt in"
- "zuhause",
- "📍"

This method is precise as the fields are key value stores. Location names that are common German words will not be misunderstood. Still location with same names, but in different regions are kept. When filtering by the user text, we can not filter by the keys above, but rely on the entity names alone.

The full region selection algorithm is shown below.

<img title="Selection of region/language" src="./graphics/region_selection.png" alt="The region language is determined in servera steps. Bavarian is selected for Bavarian users. German annd other langauge is determined by a langauage detection model." data-align="center">

#### Sentiment Analysis

The minimum of 50 characters was used, to reduce the miss classification on shorter texts.
The posts all contain a language lable, but this is set by the user or his/her application and is therefore error prone. We detect the language by the model [***papluca/xlm-roberta-base-language-detection***](https://huggingface.co/papluca/xlm-roberta-base-language-detection) with a limit 0f 100 tokens. The model is included in the Livebook smart cells.

The german sentiment analysis is done with the model [***oliverguhr/german-sentiment-bert***](https://huggingface.co/oliverguhr/german-sentiment-bert). We use the limit of 512 possible tokens of the model. We only use the first 512 tokens and do not combine the analysis of multiple sections of the text, as 512 tokens is far longer than the maximum post length of mastodon of 500 characters as default. [OPENAI](https://platform.openai.com/tokenizer) estimates 4 characters per token, but this figure does very per language and tokenizer. The German Sentiment Bert model is available as a python package. Therefore we attempted to use is in Elixir via ONNX. The problem was the correct setting of the tokenizer (bert-base-german-cased). Therefore was a  simpler alternative to use the Elixir library Bumblebee.

The English language posts are evaluated with the model [***finiteautomata/bertweet-base-sentiment-analysis***](https://huggingface.co/finiteautomata/bertweet-base-sentiment-analysis) with the limit of 130 tokens.

The whole language classification process is shown below. The sentiment is converted from thre classes (positive, negative, neutral) with a sume probability of 1 to a range -1 (negative) to 1 (positive).

<img title="" src="./graphics/language_classification.png" alt="Sentiment analysis deferernciation for the different langauages/regions." data-align="center">

#### Sentiment Graphs

The Sentiment is shown for the three regions/languages.

1) Bavaria.
2) Other German.
3) English.

For all parties most sentiments are neutral or negative. Whether positive sentiment is due to irony can not be tested automatically.

#### Correlation poll and sentiments

The polls which have a start and end date are converted into a daily and weekly timeline for each party. Each day form
start day to end day is unrolled and given the poll results for that party. When a day has a value estimated by different polling agencies, the poll result are averaged for each party. Missing daily values where filled with forward feed first and than a backward feed. The days are encoded as day of the year (day).
For the weekly timeline we take median day when each poll were executed. This median day was converted into a calendar week. When different polls were made, the results are averaged for each party.
The daily sentiment data were converted and filed in a similar fashion.
Time timelines are aligned in time by latest start date and the earliest end date. The alignments in values is done
by converting the poll results into factions and mapping the range of value of -1 to 1 to 0 to 1.

We want to estimate of either the polling or sentiment time line delayed, and how long. Therefore we estimate the cross correlation between the timelines. We adjust the timeline further by the offset between them.
For the adjusted time lime we estimate the regression between sentiment and polling.
**TODO Ridge Regression**
**TODO** bavarian Sentiments for weekly aggregate

## Results

### Polls

**TODO**: add line with election result.

As a reference the sentiment analysis will be compared to polls. Polls from different sources are listed at [wahlrecht.de](https://www.wahlrecht.de/umfragen/landtage/bayern.htm#fn-bp). With that we construct the timeline of the meta poll. The time lime for each party for the is shown below. Fitting is done with a loess fit with a bandwidth of 0.5 at the most median datetime of each poll. The result of the election is shown as `Landtagswahl`.

The strongest party `CSU` loses about three percent points since the start of the year 2023 with an result of 37 % at the election.

<img src="./graphics/polls/visualization_csu_polls.svg" title="Polls - CSU" alt="Over the last year the CSU up to 4 percent points, from a high of 41 %." data-align="center">

While its coalition partner `Freie Waehler` increases by five percent points and win 15.8 % of all votes.

<img src="./graphics/polls/visualization_fw_polls.svg" title="Polls - FW" alt="The FW gained 5 percent points since the start of the year." data-align="center">

Opposition parties as  show a trend of loosing on the lefts spectrum and gaining in the ultra right spectrum (`AFD`). As the Linke only wins less then the percent in every poll, it is not listed by every polling institute.

<img src="./graphics/polls/visualization_gruene_polls.svg" title="Polls - Buendnis 90 Gruene" alt="Buendnis 90 Gruene lost 3 percent since the beginning of the year." data-align="center">

<img src="./graphics/polls/visualization_spd_polls.svg" title="Polls - SPD" alt="" data-align="center">

<img src="./graphics/polls/visualization_afd_polls.svg" title="Polls - AFD" alt="" data-align="center">

Both Linke and and FDP did not meet the quorum of five percent. We therefore decided to ommit the gaphs.

### Posts

The cleaned posts with more than 50 characters in the evaluation data set contains 217 (median) and 248 +/- 189 (average and standard deviation) characters. The maximum was above 5000 characters.
As only German words were selected as search terms, the amount of English posts are very limited. Which might also be due to the regional nature of the election.
From the two methods of attribution sentiment towards to party, a) keeping only posts that mention only one singleparty or there candidates, or b) keeping posts that have a dominant party (or its candidates), that are mentioned *more* than 50 % of the times. After applying all filters to the *sub-sampled* dataset we either keep 39 % of all posts (method a), or 49 % of all posts (method b). The connection between post and party is more clear with method a), but we choose the method b), as more posts are kept.
Of the *sub-sample* dataset we thus label 8.1 % of posts as Bavarian. 6.14 % due the uses instance, 0.4 % due to a Bavarian location a user field and 2.0 % due to a Bavarian location name in the user notes. Although more than 13 % of German inhabitants are Bavarian.

The selected posts mainly where posted during the day, with two peek times, the late morning and early evening. While sunday shows a higher frequency of toothing, the other weekday share similar frequencies. The days with the highest frequencies are **TODO**.
<img src="./graphics/sentiment/visualization_valid_posts_frequency.svg" title="Frequency on posting on the scales, weekday, hour and doy." alt="The graphs is split into three parts. Each shows the post frequency, left on... **TODO**" data-align="center">

### Sentiments

In the *sub-sample* only the parties FW, CSU and AFD where mentioned often to contain multiple posts for most days.
Fitting is done with a loess fit with a bandwidth of 0.5.
The average sentiment (loess fit) of the CSU ranges from -0.6 to -0.4.

<img src="./graphics/sentiments/visualization_sentiment_csu.svg" title="" alt="" data-align="center">

The average sentiment (loess fit) for the FW ranges from -0.5 to -0.4.

<img src="./graphics/sentiments/visualization_sentiment_fw.svg" title="" alt="" data-align="center">

The AFD was as only mentioned in two percent of all filtered posts. Therefore the data is already sparse. Therefore the average sentiment (loess fit) has a more dynamic of -0.7 to -0.1. Computing a daily, or weekly average might be more precise.

<img src="./graphics/sentiments/visualization_sentiment_afd.svg" title="" alt="" data-align="center">

The sentiment of the posts where aggregated for the same day of the year and the same calendar week, with the mean function. Missing values are filled forward filled first and than backward filled.
For the *sub-sampled* dataset cross correlation shows an offset of zero. Hence the time series show the best correlation, when neither is shifted in the time axis. The caviat is, that the variance in sentiment is much heigher than the variance in poll results.
**TODO**: compuate variance!
**TODO**: How many polls in the time frame?


A linear ridge regression on the polls vs the sentiments, shows that the polls are independant from the sentiments.
**TODO**: errror in b?
## Discussion
**TODO** Pools samples around 1000+ people
Each polls has at least a sample size of 1000 people. We monitore posts. We do not aggregate posts for each person, nor do we create timelines for specific persons. The *sub-samples* contains **TODO** tooths, of which we estimates **XXX** as Baverian and **YYY** as other German.

Polls show, that changes in results are in the scale of weeks. The changes in polls results have to be larger than the resolution of the polls. The resolution is ± 1 %. We do not know, the assumed errors of each poll, party pair. The poll results show, that several months are needed to show changes in poll results that are long enough. In addition during most of the time only zero to one has been conducted per month.

Given that a smooth interpolation between two polls show high correlation to the real results: longer timelines have to be measured, that spann several months.
Daily sentiment analysis shows more noice than, poll results, weekly/monthly aggregated have to computed. This might be due, the higher number of samples on longer time frames, but also due to the fact that sentiments are not voting intentions. While daily, changes in poletics might show strong reactions in sentiment, voting intentions might shift on a longer time period. **TODO**

Only for few parties we have extracted enough samples. We assume, that this due to the fact, that that we did not search for the name of the parties as tags, but only for the candidates and that the national level overshadows the public reaction. Espaccially for the parties SPD, Buendis 90/ Gruene and FDP, that govern at the federal level.
**TODO**: Wow well does mastodon, is a good sample for Germany, which mitigations are possible?

**TODO**: Discussion of the applied models.

The [language selection model](https://huggingface.co/papluca/xlm-roberta-base-language-detection) lists a F1-score of 0.967 for German and 1.000 for English.
The [German language Sentiment model](https://huggingface.co/oliverguhr/german-sentiment-bert) lists an overall F1-micro score of 0.9639.
The [English language Sentiment model](https://arxiv.org/abs/2106.09462) lists an F1-score of 0.72.
Still, the models will probably not detect sarcasm, as this needs alot of background knowledge and is considered a different task in [text mining](https://arxiv.org/abs/2106.09462).
## Conclusion

Next steps, weight the Sentiment by Gender and Age according to the [Bavarian Census](https://www.statistik.bayern.de/mam/produkte/veroffentlichungen/statistische_berichte/a1310c_202200.pdf).

## Monitoring Interruptions

The monitoring service was interrupted on Sep. 30th 2023 for about 20 hours. The monitoring service was interrupted on Oct. 7th 2023. In addition monitoring was interrupted for updates on Oct. 7th.
A longer interruption took place from Oct. 28th to 31th and lasted about 85 hours.
