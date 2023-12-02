# Mastodon  - Election Predictions

## Introduction and Objectives

[Mastodon](https://blog.joinmastodon.org/2023/10/annual-report-2022/) is a micro blogging service, that is federated by the [ActivityPub](https://en.wikipedia.org/wiki/ActivityPub)
protocol and part of the fediverse. Depending on the source Mastodon 8.4 M users world wide ([fedidb](https://fedidb.org/)),  or 14.4 M users (@mastodonusercount@mastodon.social)
both on Oct. 10th 2023.
A study by the national German TV stations [ARD and ZDF](https://www.ard-zdf-onlinestudie.de/files/2023/MP_26_2023_Onlinestudie_2023_Social_Media.pdf) shows, that about two percent of all Germans are weekly recurring Mastodon users. Two percvent of both men and women. This means about 1.7 mil weekly recurring users from Germany.
Mastodon reaches up to three percent for those aged 14 to 49. Because many services (and their instances) are able to federate with each other, it is possible to read posts from other services as Misskey,
Lemmy, Pixelfed and so on. Even some Wordpress-Blogs can be read.

Mastodon instances are often centered around a topic or a region.
There is a relative high number regional instances  (see [OSM - Mastodon server](https://umap.openstreetmap.fr/en/map/mastodon-near-me-global-mastodon-server-list-by-co_828094)).
A high number are German.  Mastodon had a strong spike in usage in Nov. 2022 with 2.5 M monthly recurrent users. Currently the network has still [1.7 mil.](https://joinmastodon.org/servers) monthly recurrent users.
We analyse Mastodon toots with the topic Bavaria state election which took place on Oct. 8th 2023. We apply a sentiment analysis. We attempt to differentiate regions into Bavaria and other German.

We use the sentiment and frequency of mentioned persons and parties. We do not consider favorisation, reblogs or replies. In addition we only did not try to monitor [voting intention](https://www.sciencedirect.com/science/article/pii/S0740624X21000940).
Beside Mastodon, [X](https://developer.twitter.com/en/docs/twitter-api) was also investigated as possible source. But was excluded for
[monetary reasons](https://www.heise.de/news/API-Zugriff-nur-gegen-Geld-Ueber-100-Forschungsprojekte-zu-X-Twitter-gestoppt-9355078.html?wt_mc=sm.red.ho.mastodon.mastodon.md_beitraege.md_beitraege).
We will use the terms posts and toots interchangeably. We call a user that wrote a peticular post a author. One limiting issue is the sample size of users, that use these services. The other is demographics.

### Monitored Parties

The sentiment for the following candidates and parties were monitored (sorted from left to right):

| Party                     | Candidate(s)                        | Percentage 2018 | Percentage 2023 |
|:------------------------- |:----------------------------------- |:--------------- |:--------------- |
| AfD                       | Katrin Ebner-Steiner & Martin Böhm  | 10.2            | 14.6            |
| CSU (Baverian only party) | Markus Söder                        | 37.2            | 37.0            |
| FDP                       | Martin Hagen                        | 5.1             | 3.0             |
| Freie Wähler              | Hubert Aiwanger                     | 11.6            | 15.8            |
| Grüne                     | Ludwig Hartmann & Katharina Schulze | 17.6            | 14.4            |
| SPD                       | Florian von Brunn                   | 9.7             | 8.4             |
| Linke                     | Adelheid Rupp                       | 3.2             | 1.5             |

Source: [Landtagswahl in Bayern 2023: Kandidaten, Themen, Termin | BR24](https://www.br.de/nachrichten/bayern/landtagswahl-in-bayern-2023-termin-themen-kandidaten,TMD4uSM)

[Bayerische Linke kürt Adelheid Rupp als Spitzenkandidatin | BR24](https://www.br.de/nachrichten/bayern/bayerische-linke-kuert-adelheid-rupp-als-spitzenkandidatin,TZXl5yd)

## Bavaria Demographics

Bavaria has about 13.3 mil. inhabitants and slightly more woman (50.5 %) [Bevölkerung in den Gemeinden Bayerns nach Altersgruppen und Geschlecht](https://www.statistik.bayern.de/mam/produkte/veroffentlichungen/statistische_berichte/a1310c_202200.pdf).
This is due to the age distribution of its citizen, caused by a higher mortability rate of man at higher ages. The peer group aged 40 to 50 is the first one with more than 50 % women.
All younger peer groups show an surplus of men by two to five percent. On the other hand, the peer group of age 75 or older shows a surplus of women of about 17 %.

## Methods

### Monitoring

Following tags are monitored on the instance *chaos.social*. We group the tags by topics:

- Bavaria: bayern bayernwahl bayernwahl2023 
- Election: wahlen wahlkampf wahlumfrage wahlen23 wahlen2023 
- Partys: spd csu gruene  grune gruenen grunen afd freiewaehler freiewahler fw fpd linke
- Candidates: markussoeder markussoder soeder soder hubertaiwanger aiwanger hartmann martinhagen ebnersteiner

Some candidates were not included, because their name were not used as tags at the beginning of the study. We only used German words as tags.

A wide set of topics have been selected to retrieve a maximum of tagged posts. Due to the concept of federation of instances, it is possible that not all instances share posts, or not all posts. Still only a single instance have been monitored to reduce the need of removing duplicates with different ids on each instance.

Search of posts without the need of tags, has been released during the monitoring with Mastodon version 4.2 in the end of Sep. 2023.  It was added on Oct. 3rd on chaos.social. Reindexing stated have been finished on Oct. 5th. We added search on Oct. 7th to the monitoring. The end date of data generation was Nov. 19th 2023.

We retrieve the tags via the public timeline of the instance and the search via the search api

* ***instance_url/api/v1/timelines/tag/{tag_name}*** 
* ***isntance_url/api/v2/search?q={search_word}***

Search of tags in the public timeline is done without a login, therefore only public posts are monitored. For the search a bearer token is needed. During the addition of the search the limit of requested post was increased from 20 (default) to 40 (maximum).

The posts are requested every full hour starting Aug. 29th 2023. The retrieval is done with a Elixir programm that runs on Erlang's BEAM runtime, to increase stabiliy. For instance automatic recovering after failing connections. Each post is written into four tables of a SQLite3 database. The `toots` table contains the post itself and some of its meta data. The `users` table contains some meta data of the posts about the users, who wrote the posts. The related table `fields` contains the fields a user can set using key value pairs, to add some information about him-/herself. The related `tags` table contains all tags of each post.

Depending on the search term and how often it is used in posts, the time range of  a look back of 20/40  posts varies. For some search terms, that are less frequent used, it lasts back several years. For other terms it ranges back several days only. This behaviour partially heals interruptions in the monitoring service. This could be used to look back further, when using very specific search terms combined with the used language.

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
3) Keep only posts that is attributable a single or dominant party.

#### Regional Filter

The regional filter accepts any post that abides to any of the the three rules

1) (Raw) Post must name of any local entity.
2) (Raw) Post must name of any candidate.
3) (Raw) Post must name csu (single regional party).

We use 3890 local entities from the state name down to village names. We do not use the 7860 sub-district names, as they amount is much higher as and includes some major common German words (e.g. Gern, Oder).
Is also partially true for villages names, (e.g. Wald). This filter method, may also keep posts which mention similar names, in other regions of the world.

### Attribute Sentiment to Party

To select (raw) posts, that's sentiment can me attributed to a party we test two methods:

1) Keep posts, that only name a single party, or their candidate(s).
2) Keep posts, that contains a dominant party, that is mentioned more often than, all other party combined.

#### Spatial Differentiation

Based on [OSM - Mastodon server](https://umap.openstreetmap.fr/en/map/mastodon-near-me-global-mastodon-server-list-by-co_828094) Mastodon instances are estimated to be used by Bavarian users (see Appendix). We added sueden.social based on the untested hypothesis, that the overall sentiment in southern Germany is similar to Bavaria.
In addition the fields and notes of each user are scanned for Bavarian location names [OpenData Geodaten Bayern](https://geodaten.bayern.de/opengeodata/OpenDataDetail.html?pn=verwaltung) from the state name down to village name (as described above).

This method is precise as the fields are key value stores. Location names that are common German words will not be misunderstood, but location with same names, but in different regions are kept. When filtering by the user text, we can not filter by the keys above, but rely on the entity names alone. The full region selection algorithm is shown below.

<img title="Selection of region/language" src="./graphics/region_selection.png" alt="The region language is determined in servera steps. Bavarian is selected for Bavarian users. German annd other langauge is determined by a langauage detection model." data-align="center">

#### Sentiment Analysis

The minimum of 50 characters was used, to reduce the miss classification, that may happen on shorter texts. The posts all contain a language label, but this is set by the user or his/her application and is therefore error prone.  We detect the language by the model [***papluca/xlm-roberta-base-language-detection***](https://huggingface.co/papluca/xlm-roberta-base-language-detection) with a limit 0f 100 tokens.
The model is included in the Livebook smart cells.

The German sentiment analysis is done with the model [***oliverguhr/german-sentiment-bert***](https://huggingface.co/oliverguhr/german-sentiment-bert). We use the limit of 512 possible tokens of the model. We only use the first 512 tokens and do not combine the analysis of multiple sections of the text. 512 tokens is far longer than the maximum post length of mastodon of 500 characters as default. [OPENAI](https://platform.openai.com/tokenizer) estimates 4 characters per token, but this figure does very per language and tokenizer. The German Sentiment Bert model is available as a python package.
Therefore we attempted to use is in Elixir via ONNX. The problem was the correct setting of the tokenizer (bert-base-german-cased). Therefore, we applied the alternative to use the Elixir library Bumblebee.

The English language posts are evaluated with the model [***finiteautomata/bertweet-base-sentiment-analysis***](https://huggingface.co/finiteautomata/bertweet-base-sentiment-analysis) with the limit of 130 tokens.

The whole language classification process is shown below. The sentiment is converted from three classes (positive, negative, neutral) with a probability of 1 to a range -1 (negative) to 1 (positive).

<img title="" src="./graphics/language_classification.png" alt="Sentiment analysis deferernciation for the different langauages/regions." data-align="center">

#### Sentiment Graphs

The Sentiment is shown for the regions/languages.

1) Bavaria.
2) Other German.

For all parties most sentiments are neutral or negative. Whether positive sentiment is due to [irony](https://www.sciencedirect.com/science/article/pii/S0306457318307428) is not tested automatically.

#### Correlate polls and sentiments

The polls which have a start and end date are converted into a daily and weekly timeline for each party. For the daily poll timeline each day form start day to end day is unrolled and given the poll results for that party. When a day has a value estimated by different polling agencies, the poll result are averaged for each party. Missing daily values where filled with forward feed first and than a backward feed. The days are encoded as day of the year (day).
For the weekly timeline we take median day when each poll were executed. This median day was converted into a calendar week. When different polls were made, the results are averaged for each party.
The daily and weekly sentiment data were converted and filed in a similar fashion.
The timelines are aligned in time by latest start date and the earliest end date. The alignments in values is done by converting the poll results into fractions and mapping the range of the sentiment values of -1 to 1 to  a ratio of the sentiments of all parties from 0 to 1.

We want to estimate of either the polling or sentiment time line delayed, and how long. Therefore we estimate the cross correlation between the timelines. We adjust the timeline further by the offset between them. For the adjusted time lime we estimate the linear regression between sentiment and polling.

## Results

### Polls

As a reference the sentiment analysis will be compared to polls. Polls from different sources are listed at [wahlrecht.de](https://www.wahlrecht.de/umfragen/landtage/bayern.htm#fn-bp). With that we construct the timeline of a meta poll. The timeline for each party for the is shown below. Fitting is done with a loess fit with a bandwidth of 0.5 on the median datetime of each poll in dark red. The result of the election is shown as a blue line.

The strongest party `CSU` loses about three percent points since the start of the year 2023 with an result of 37 % at the election.

<img src="./graphics/polls/visualization_csu_polls.svg" title="Polls - CSU" alt="Over the last year the CSU up to 4 percent points, from a high of 41 %." data-align="center">

While its coalition partner `Freie Waehler` increases by five percent points and win 15.8 % of all votes.

<img src="./graphics/polls/visualization_fw_polls.svg" title="Polls - FW" alt="The FW gained 5 percent points since the start of the year." data-align="center">

Opposition parties as  show a trend of loosing on the lefts spectrum and gaining in the ultra right spectrum (`AFD`). As the `Linke` only wins less then the percent in every poll, it is not listed by every polling institute.

<img src="./graphics/polls/visualization_gruene_polls.svg" title="Polls - Buendnis 90 Gruene" alt="Buendnis 90 Gruene lost 3 percent since the beginning of the year." data-align="center">

<img src="./graphics/polls/visualization_spd_polls.svg" title="Polls - SPD" alt="" data-align="center">

<img src="./graphics/polls/visualization_afd_polls.svg" title="Polls - AFD" alt="" data-align="center">

Both `Linke` and `FDP` did not meet the quorum of five percent. We therefore decided to omit the graphs.
Overall the fit of polls for each party is at most one percent of the final result.
The last polls before the election we conducted by `Forschungsgruppe Wahlen` and `INSA`.
`Forschungsgruppe Wahlen` shows an average error per party of 0.87 percent points and `INSA` 0.73 percentage points.
The larger error for `Forschungsgruppe Wahlen` is caused because they did not add a estimation for `Die Linke`.

### Posts

In the *sub-sample* the cleaned posts with more than 50 characters in the evaluation data set contains 217 (median) and 248 ± 189 (average and standard deviation) characters. The maximum was above 5000 characters.
While in the full sample this changes to 281 ± 358 with a maximum of over 19000 characters and a median of 228 characters.
As only German words were selected as search terms, the amount of English posts are very limited. Which might also be enhanced by the regional nature of the election.
From the two methods of attribution sentiment towards a party, a) keeping only posts that mention only one single party or there candidates, or b) keeping posts that have a dominant party (or its candidates), that are mentioned *more* than 50 % of the times.
After applying all filters to the *sub-sampled* dataset we either keep 39 % of all posts (method a), or 49 % of all posts (method b).
The connection between post and party is more clear with method a), but we choose the method b), as more posts are preserved.
In addition we changed from Regional and Party filter based on the cleared posts, to the raw posts. Cleaning removes *some* tags, which are only included as html-Code. This enables us to keep 58 % percent of the posts of the *sub-Sample*.
Of the *sub-sample* dataset we thus label 8.1 % of posts as Bavarian. 6.14 % due the uses instance, 0.4 % due to a Bavarian location a user field and 2.0 % due to a Bavarian location name in the user notes.
The *sub-samples* contains 2126 toots of which we estimates 207 as Bavarian and 1902 as other German.

|                      | Sub-Sample | Full Sample |
|---------------------:|-----------:|------------:|
| Total Count          |       4563 |       33142 |
| Topic: Bavaria       |       3363 |       10001 |
| With dominant Party  |       2627 |        5763 |
| Bavarian Authors     |        249 |         549 |
| Other German Authors |       2255 |        4921 |

In the *full sample* 307 users (3.88 % percent) are from Bavaria. 2.68 % percent due to instance, 0.18 % due to user fields and 1.19 % due to user notes.
In contrast, when we only consider posts that were kept after filtering: we keep 160 (8.9 %) Bavarian users and 1628 other German users.
We thus label of all posts we kept after filtering: 549 toots (10.0 %) as Bavarian
and 4235 toots as other German.
Although more than 15 % of German inhabitants are Bavarian.

Most posts (91.5 %) where self-labelled as German, while after language classification we revaluate to 97.7 % of the posts are German. About 6 % percent of the posts are relabel. Mostly from the language settings: "en", nil and "en-us". We assume, that this are standard setting of the posting tools, that have not be changed.

The selected German and Bavarian posts mainly where posted during the day, with two peek times, the morning and afternoon. While Sunday shows a higher frequency of tooting, the other weekday share similar frequencies. The days with the highest frequencies are is the 247th day of the year (Sept 4th) and the election day (Oct 8th). The time is recorded in UTC. In general we observe more posts during the Aiwanger affair, than around the election day.
<img title="Frequency on posting on the scales, weekday, hour and doy." src="./graphics/sentiments/visualization_valid_posts_frequency.svg" alt="The graphs is split into three parts. Each shows the post frequency, left for the days, center for the Weekdays and right for the Hours." data-align="center">

### Sentiments

In the *sub-sample* only the parties `FW`, `CSU` and `AFD` where mentioned often to contain multiple posts for most days. This situation was enhanced by adding the the search for data retrieval and the longer entry list of 40 posts. We than got more posts for the other parties and have several posts per day for the `SPD`.
Fitting is done with a loess fit with a bandwidth of 0.5.
About 37 % of all toots mention the `CSU` as main political topic. The average sentiment (loess fit) of the CSU ranges from -0.5 to -0.4.

<img src="./graphics/sentiments/visualization_sentiment_csu.svg" title="" alt="" data-align="center">

About 44 % percent of the posts main topic is the `FW`. The average sentiment (loess fit) for the FW is around -0.5.

<img src="./graphics/sentiments/visualization_sentiment_fw.svg" title="" alt="" data-align="center">

The `AFD` was as mentioned in twelve percent of all filtered posts. The the loess fit of the sentiment is in the range of -0.4.

<img src="./graphics/sentiments/visualization_sentiment_afd.svg" title="" alt="" data-align="center">

The count of mentioned parties over the full filtered sample is listed in the table below.
Beside the percentage based ony the full count of toots, we also show the the percentage
of all posts weighted by the count of followers of the author of each post.
Finally, we also show the percentage posts by Bavarian users.

| Party  | Percentage | Percentage Followers | Percentage Bavaria | Election Result |
| ------ | ----------:| --------------------:| ------------------:| ---------------:|
| AFD    | 11.7 %     | 18.4 %               | 11.0 %             | 14.6 %          |
| CSU    | 30.7 %     | 28.5 %               | 32.6 %             | 37.0 %          |
| FDP    | 1.9 %      | 0.7 %                | 1.3 %              | 3.0 %           |
| FW     | 47.7 %     | 45.3 %               | 49.1 %             | 15.8 %          |
| Gruene | 3.0 %      | 1.2 %                | 1.8 %              | 14.4 %          |
| Linke  | 1.3 %      | 1.7 %                | 1.8 %              | 1.5 %           |
| SPD    | 3.7 %      | 4.1 %                | 2.1 %              | 8.4 %           |

These Percentages are 30 percent points to high for `Freie Waehler`.
Therefore, we estimate the same data again, but only within the time period of
doy 260 (Sep. 17th) to 280 (Oct. 7th). After the Aiwanger affair calmed down to the day before the election.

| Party  | Percentage | Percentage Followers | Percentage Bavaria | Election Result |
| ------ | ----------:| --------------------:| ------------------:| ---------------:|
| AFD    | 20.6 %     | 46.9 %               | 17.3 %             | 14.6 %          |
| CSU    | 45.3 %     | 30.5 %               | 42.7 %             | 37.0 %          |
| FDP    | 1.3 %      | 0.3 %                |  0.9 %             | 3.0 %           |
| FW     | 21.6 %     | 14.9 %               | 28.2 %             | 15.8 %          |
| Gruene | 5.9 %      | 4.1 %                |  6.4 %             | 14.4 %          |
| Linke  | 0.7 %      | 0.0 %                |  0.9 %             | 1.5 %           |
| SPD    | 4.6 %      | 3.2 %                |  3.6 %             | 8.4 %           |

This increases the accuracy for the `FW`, and `SPD`, but still strongly underestimate the `Gruene` party.
Finally, we add the condition to only keep the most positive posts per user. This is closer to a voting intent.  We still overestimate the `CSU` and `FW`. All this filtering results in very small supports for Bavarian authors.

| Party  | Percentage | Percentage Followers | Percentage Bavaria | Election Result |
| ------ | ----------:| --------------------:| ------------------:| ---------------:|
| AFD    | 18.7 %     | 43.2 %               | 16.1 %             | 14.6 %          |
| CSU    | 45.9 %     | 31.1 %               | 38.1 %             | 37.0 %          |
| FDP    | 1.0 %      | 0.7 %                | ---  %             | 3.0 %           |
| FW     | 22.0 %     | 14.1 %               | 30.6 %             | 15.8 %          |
| Gruene | 6.4 %      | 2.0 %                | 8.1 %              | 14.4 %          |
| Linke  | 1.4 %      | 0.3 %                | 1.6 %              | 1.5 %           |
| SPD    | 4.6 %      | 8.8 %                | 4.8 %              | 8.4 %           |

When using a weighted mean based on the follower count of the authors, we get a strong bias towards the `AFD`.
The average error per party is well above the other methods tested here.
Removing Data Before the Aiwanger affair, reduced the average error per party from about 8 to 9 percentage points, to 5 percentage points. Using the most positive Sentiment per author, again reduced the error to 4.4 to 4.7 percentage points. We could reduce the error to 4.4 percentage points when we filter for Bavarian users, but the difference to other German users with 4.7 is low.

### Compare Sentiments and Polls

$$
S_n(party) = \frac{S(party) + 1}{2}
$$

The sentiment is shifted from the range -1 to 1 to the range 0 to 1.  The sentiment of the posts where aggregated for the same calendar week, with the mean function. Missing values are filled forward filled first and than backward filled.

$$
S_p (party) =  \frac{S_n(party)}{∑_{party} S_n} 
$$

Than the sentiment is converted into a ratio of sentiment per party by the sum of the sentiments of all parties for the same week. When comparing the daily aggregate and the weekly aggregate, we can see, that the variance is much higher for the sentiment compared to the polls. This strongly reduces for the weekly aggregate, but still here the timelines do not correlate.

![Compary Daily Timelines Polls and Sentiments for FW](.\graphics\comparision\visualization_fw_daily_compare.svg)
![Compary Weekly Timelines Polls and Sentiments for FW](.\graphics\comparision\visualization_fw_weekly_compare.svg)

Still the ratio of the sentiment for the `FW` is much higher, than the election result.
We would also overestimate the result of the `AFD` and underestimate the result of the `CSU`, at any given point in time.

![Compary Weekly Timelines Polls and Sentiments for AFD](.\graphics\comparision\visualization_afd_weekly_compare.svg)
![Compary Weekly Timelines Polls and Sentiments for CSU](.\graphics\comparision\visualization_csu_weekly_compare.svg)

The graph, that compares the polling result to the sentiments, shows that the main dependency is the party itself.
![Compary Weekly Timelines Polls and Sentiments for all Parties](.\graphics\comparision\visualization_weekly_compare.svg)

The offset of the cross correlation for the timelines for all parties is zero. 

As the predict is already grouped into calendar week, we do not estimate the difference between Bavarian an other German posts, in order to not again reduce the support. For the calendar week 40 (week of the election) the sentiment based election prediction is shown below. This approach strongly overestimates smaller and left wing parties. The prediction of all parties are much closer to each other. In addition to the bare sentiment for KW we apply a linear fit between the polls and the weekly sentiment $ S_p $ for the last six election week.
The parties are one-hot encoded. Hence, the sum of the intersection and the slope for the party, can be seen as intercept for each party. The dependency is much stronger on the party. The slope for the sentiment is only 0.024.
Which means, that in the model the Sentiment only accounts for a maximum of 2.4 Percentage points. Everthing else is depending on the party itself. r²-score on the test dataset is 0.997. The fit for calendar week 40, is shown in the table below.
The average error is 0.40 percentage points. This is less than the error of the last polls
of `Forschungsgruppe Wahlen` and `INSA`. This is about the average error over all polls of the last six weeks, which is 0.39.

| Party  | Sentiment KW 40 | Average Polls | Fit KW 40 | Election Result |
| ------ | ---------------:| -------------:| ---------:| ---------------:|
| AFD    | 15.8            | 13.9 %        | 14.1 %    | 14.6 %          |
| CSU    | 15.4            | 36.4 %        | 36.4 %    | 37.0 %          |
| FDP    | 12.7            | 3.4 %         | 3.4 %     | 3.0 %           |
| FW     | 13.7            | 16.0 %        | 16.2 %    | 15.8 %          |
| Gruene | 19.2            | 14.6 %        | 14.6 %    | 14.4 %          |
| Linke  | 8.4             | 1.4 %         | 1.4 %     | 1.5 %           |
| SPD    | 14.7            | 9.0 %         | 9.0 %     | 8.4 %           |

## Discussion

Each poll has at least a sample size of 1000 people. In contrast we monitor posts. It does reach a figure of more than 1000 other German users per week, but only 120 Bavarian users per week, which results very likely in an unrepresentative sampling. The number of English language toots is to low, and therefore omitted.
In the full sample this extends to only 445 Bavarian toots and 4235 other German. Especially the addition of search increases the samples from the parties `Buendis 90 / Gruene`, `SPD` and `FDP` and `Linke`. Most toots about the `FW` are made at the start of the sampling period, when the [Anti-Semitic pamphlet](https://en.wikipedia.org/wiki/Hubert_Aiwanger) affair was the main topic of the election.
The number of posts we evaluated is very low. The ability to distinguish the Bavarian posts from other German posts is very limited. The differences that are shown in the frequencies thus have limited information value.

Polls show, that changes in results are in the scale of weeks. The changes in polls results have to be larger than the resolution of the polls. The resolution is ± 1 %.
We do not know, the assumed errors of each poll, party pair. The poll results show,
that several months are needed to show changes in poll results that are long enough, compared to this error.

Given that a smooth interpolation between two polls show high correlation to the real results: longer timelines have to be measured, that span several months. Daily sentiment analysis shows more noise than poll results, weekly/monthly aggregated have to computed.  This might be due, the higher number of samples on longer time frames, but also due to the fact that sentiments are not voting intentions. While daily changes in politics might show strong reactions in sentiment, we assume voting intentions might shift only on a longer time period.

Only for few parties we have extracted enough samples. We assume, that this due to the fact, that that we did not search for the name of the parties as tags,
but only for the candidates and that the national level overshadows the public reaction. Especially for the parties `SPD`, `Buendis 90/ Gruene` and `FDP`, that govern at the federal level. Thus, sentiment analysis on a national scale is more promising.

We tried to predict election result with two different versions:

1) Frequency based,
2) Sentiment based.

The frequency based version favoured the `FW` strongly above their election result by about 20 percentage points.  After removing all mentions in the period of the Aiwanger affair, this effect could be greatly reduced. We still strongly favour the `FW`, 4 to 10 percentage points above their potential.  But this methods than strongly overestimates the result of the `CSU` by about 14 to 20 percentage points. This might be due to the strongly local factor in both parties. So that both, are less overshadowed by
national politics as other parties.

When we compare the error of the predicted election result to the election result,
get an average error of five to nine percentage points per party.  The best predictions is made by German estimates between Sep. 17th  and Oct. 7th. for the highest sentiment per user with an average error of 5.5 percentage points and the estimates of Bavaria in the time between Sep. 17th  and Oct. 7th. with an average 6 percentage points.
On average removing the time period of the affair reduces the average error from 8 to 6 percentage points.
The variance between the predictions from the Bavarian posts, compared to other German posts is about 0.83 percentage points. But there is no clear benefit of selecting Bavarian posts only. As there predictions is sometimes worse.

In the end, the frequency based approach favour parties with higher post frequencies `CSU` and `FW`.  Considering the sentiment based method we can see, that the weekly sentiment for the parties `CSU`, `FW` and `AFD` are very similar in the region above 0.25 to 0.35. This is also true for the other parties as `SPD`. The sentiment for the `Buendis 90 / Gruene` is 0.1 higher. 
Filtering by the most positive mentioned party per author, did not lead to better results. We assume, that while not all parties are mentioned per user, the true vote intent is still hidden, as we might select a neutral post, or the least negative mentioned party instead.

The [language selection model](https://huggingface.co/papluca/xlm-roberta-base-language-detection) lists a F1-score of 0.967 for German and 1.000 for English. The [German language Sentiment model](https://huggingface.co/oliverguhr/german-sentiment-bert) lists an overall F1-micro score of 0.9639.  The [English language Sentiment model](https://arxiv.org/abs/2106.09462) lists an F1-score of 0.72.
Still, the models can not detect sarcasm, as this needs a lot of background knowledge and is considered a different task in [text mining](https://arxiv.org/abs/2106.09462).

About 9.5 % of all kept posts, where label as Bavarian. We do not know, whether this is due to lower number of Bavarian, who use Mastodon, or whether they use generalised instances, thus we could not estimate as Bavarian users. We tried to mitigate this problem with the self-disclosure in user fields and user texts. We did not try to classify the user by there language usage. The best result, was based on the polling data. The average of the polls of the last six weeks, before for the election. Resulted into very small error, of 0.39 percentage points per party.
This could be reduced to 0.35 percentage points, by a fit of the Sentiment analysis
for the polls of each party. The dependency of the poll result from the Sentiment was small. It has to be tested, whether this effect can be repeated for other elections.

## Conclusion

We see strong problem for using Mastodon as a basis for polling (regional) elections.
We assume, that for national elections Mastodon might be a better data source.
The number of toots in regional election was low. We only got a high number of posts during the Aiwanger affair, which bias the frequencies for each party.

In additional we assume, that he user pool is not representative is for the demographics of Germany or any German state. We therefore propose a two layered
strategy to mitigate this, by a weighted average of the user data.
We propose, that gender, can be extracted from user data, as user name, user fields and user texts. For users, that do not share this information we propose an image classification.
Similar we propose an image classification to retrieve the age of the users. For images with no person or multiple persons, we assume an random gender and
a random age (drown from the image/user statistic). Some models for the age an gender classification are listed [here](https://paperswithcode.com/sota/age-and-gender-classification-on-adience) and also in the [ONNX model zoo](https://github.com/onnx/models/tree/main/vision/body_analysis/age_gender).
We than could compare the demographics to [Bavarian Census](https://www.statistik.bayern.de/mam/produkte/veroffentlichungen/statistische_berichte/a1310c_202200.pdf).

### Appendix

#### List of Bavarian Instances

- muenchen.social
- augsburg.social
- mastodon.bayern
- nuernberg.social
- ploen.social
- wue.social (Würzburg)
- mastodon.dachgau.social
- sueden.social

sueden.social is a more general instance for southern Germany, but we assume, that the overlapping and regional proximity, lead to a similar sentiment. 

#### List of Keywords in Table fields, that transcode locations

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

#### Monitoring Interruptions

The monitoring service was interrupted on Sep. 30th 2023 for about 20 hours,  on Oct. 7th 2023 for the update. A longer interruption took place from Oct. 28th to 31th and lasted about 85 hours.

#### Tech stack

Saving Mastodon data into a SQLite database is done with a Elixir project with mix.
The Mastodon api is called with HTTPoison. Ecto applied to write the reply into a SQLite3 database.
Cron is utilised to hourly trigger the api calls with Quantum.

The data evaluation is done with the Nx framework. The first version of Nx was released 01/06/2022. Nx enables the numerical computation in Elixir and is used for Machine Learning (Scholar) and Deep Learning libraries (Axon). For instance with an EXLA compiler as backed.
The packages are still in development and sometimes, new functions and fixes, were just released during the project.
For instance the week_of_year function was created for [this project](https://elixirforum.com/t/missing-functions-in-explorer-dataframes-series/58448/6).
