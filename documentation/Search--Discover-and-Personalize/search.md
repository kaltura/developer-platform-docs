---
layout: page
title: Searching with Kaltura's eSearch API 
weight: 110
---


If you’ve had experience building search capabilities into your video applications, you know that indexing and searching video content is complex - not only due to the time dimension, but because it also requires searching through many objects and related metadata. You’ve had to write multiple queries that are time consuming, fragile at scale and hard to optimize for performance.

We’re excited to introduce a new Kaltura search API that will revolutionize how video search is done. Leveraging the Elastic Search engine, eSearch exposes a set of API actions that unlock a variety of search capabilities and simplify how video search is done.

You can try it out yourself in the [console](https://developer.kaltura.com/console/service/eSearch/action/searchEntry), and we’ll demonstrate a few of the cool features below:

## Search Term Highlighting 

A really neat feature, highlighting, gives you insight on why a particular object was returned in the search results, meaning, what caused the object to match the query.
Let’s assume you have an account in Kaltura with over a thousand entries and you’re looking for a pasta recipe. Searching “pasta” with the unified search would search through all entry data - and this is where highlighting comes in: you’d be able to determine whether pasta was found in the captions, description, or simply just the entry name.

{% highlight php %}
<?php
$unifiedItem = new KalturaESearchUnifiedItem ();
$unifiedItem->searchTerm = 'pasta';
$unifiedItem->itemType = KalturaESearchItemType::EXACT_MATCH;
$unifiedItem->addHighlight = true;

$searchOperator = new KalturaESearchEntryOperator();
$searchOperator->searchItems = array($unifiedItem);

$searchParams = new KalturaESearchEntryParams();
$searchParams->searchOperator = $searchOperator;
$elasticsearchPlugin = KalturaElasticSearchClientPlugin::get($client);
$searchResults = $elasticsearchPlugin->eSearch->searchEntry($searchParams, null);
{% endhighlight %}

### Results

{% highlight json %}
{
"totalCount":1,
"objects":[ {
"object":{
...
"id":"12345",
"name":"delicious pasta recipe",
"description":"delicious pasta recipe",
...
...
"highlight":[
{ "fieldName":"description",
"hits":[
{ "value":"delicious <em>pasta<\/em> recipe",
"objectType":"KalturaString" }],
"objectType":"KalturaESearchHighlight" },
{ "fieldName":"name",
"hits":[
{ "value":"delicious <em>pasta<\/em> recipe",
"objectType":"KalturaString" }],
"objectType":"KalturaESearchHighlight" } ]
}
}
}
{% endhighlight %}

## Partial Search
Sometimes you can’t be sure about the exact phrase to search. Perhaps you’re not sure if the entry is listed under “cake” or “cupcake.”
Enter partial search. It is exactly what it sounds like.

{% highlight php %}
<?php
$entryNameItem = new KalturaESearchEntryItem();
$entryNameItem->searchTerm = 'cake';
$entryNameItem->itemType = KalturaESearchItemType::PARTIAL;
$entryNameItem->fieldName = KalturaESearchEntryFieldName::NAME;

$entryNameItem->addHighlight = true;

$searchOperator = new KalturaESearchEntryOperator();
$searchOperator->searchItems = array($entryNameItem);

$searchParams = new KalturaESearchEntryParams();
$searchParams->searchOperator = $searchOperator;
$elasticsearchPlugin = KalturaElasticSearchClientPlugin::get($client);
$searchResults = $elasticsearchPlugin->eSearch->searchEntry($searchParams, null);
{% endhighlight %}

### Results

{% highlight json %}
{
"hits":[ {
"value": cup<em>cake</em>",
"objectType":"KalturaString"
}]
}
{% endhighlight %}

## Synonyms

At this point you’re just hungry and you don’t care whether the recipe is for pasta or salmon. You’d like to eat something “delicious”, but you’re open to “yummy” as well. This is another case for the partial feature, which uses the WordNet English synonym dictionary by default and gets you that recipe with fewer searches!

{% highlight php %} 
<?php
$entryNameItem = new KalturaESearchEntryItem(); $entryNameItem->searchTerm = 'delicious'; 
$entryNameItem->itemType = KalturaESearchItemType::PARTIAL; 
$entryNameItem->fieldName = KalturaESearchEntryFieldName::NAME; $entryNameItem->addHighlight = true; 
$searchOperator = new KalturaESearchEntryOperator(); 

$searchOperator->searchItems = array($entryNameItem);
$searchParams = new KalturaESearchEntryParams();

$searchParams->searchOperator = $searchOperator; 
$elasticsearchPlugin = KalturaElasticSearchClientPlugin::get($client); 
$searchResults = $elasticsearchPlugin->eSearch->searchEntry($searchParams, null);
{% endhighlight %}

### Results

{% highlight json %}
{
"hits":[ {  "value":"<em>yummy<\/em> recipe", } ],
    "objectType":"KalturaESearchHighlight"       
}
{% endhighlight %}
    
## Multi-Language

Now imagine that you have recipes with captions in various languages, such as Chinese or German. eSearch supports searching across 22 languages (and we’ll be adding more!), including; Spanish, French, Russian, Dutch, Chinese. Let’s demonstrate searching inside captions for the Chinese phrase 食谱 which, you guessed it, means recipe.

{% highlight php %}
<?php
$captionItem = new KalturaESearchCaptionItem();
$captionItem->searchTerm = '食谱';
$captionItem->itemType = KalturaESearchItemType::PARTIAL;
$captionItem->fieldName = KalturaESearchCaptionFieldName::CONTENT;
$captionItem->addHighlight = true;

$searchOperator = new KalturaESearchEntryOperator();
$searchOperator->searchItems = array($captionItem);

$searchParams = new KalturaESearchEntryParams();
$searchParams->searchOperator = $searchOperator;
$elasticsearchPlugin = KalturaElasticSearchClientPlugin::get($client);
$searchResults = $elasticsearchPlugin->eSearch->searchEntry($searchParams, null);
{% endhighlight %}

### Results

{% highlight json %}
{
"name":"Amazing recipes",
"items":[
{ "line":"\u98df\u8c31",
"startsAt":0,
"endsAt":10000,
"language":"Chinese",
"captionAssetId":"0_5ifj0qhq",
"highlight":[
{ "fieldName":"caption_assets.content.raw",
"hits": [
{ "value":"<em>\u98df\u8c31<\/em>",
"objectType":"KalturaString" }]
}
{% endhighlight %}

## Custom Metadata Profiles and Fields

The unified option searches through all of the entry’s related objects - such as captions, metadata, and cue-points but if you know where your keyword is, with eSearch it is just as easy to search through specific objects.

{% highlight php %}
<?php
$metadataItem = new KalturaESearchEntryMetadataItem();
$metadataItem->searchTerm = 'recipe';
$metadataItem->itemType = KalturaESearchItemType::STARTS_WITH;
$metadataItem->metadataProfileId = 653;
$metadataItem->addHighlight = true;
{% endhighlight %}

> By default, custom metadata search goes through all fields in the chosen profile (metadataProfileId). To define a specific field, you could set the x-path attribute like so:

$metadataItem->xpath = "/*[local-name()='metadata']/*[local-name()='Field1']";
$searchOperator = new KalturaESearchEntryOperator();
$searchOperator->searchItems = array($metadataItem);

$searchParams = new KalturaESearchEntryParams();
$searchParams->searchOperator = $searchOperator;
$elasticsearchPlugin = KalturaElasticSearchClientPlugin::get($client);
$searchResults = $elasticsearchPlugin->eSearch->searchEntry($searchParams, null);

### Results

{% highlight json %}
{
"xpath":"/* local-name()='metadata' /* local-name()='Field1'",
"metadataProfileId":653,
"metadataFieldId":668,
"valueText":"recipe",
"highlight":[
    {  "fieldName":"metadata.value_text.raw",
        "hits":[
            {  "value":"<em>recipe<\/em>",
                "objectType":"KalturaString" } ],
        "objectType":"KalturaESearchHighlight" } ]
}
{% endhighlight %}

Searching in Cue Points
Video often includes temporal (time based) metadata such as annotations, comments, notes, overlays, in-video chapters and markers, synced powerpoint slides, or descriptive data (often generated by video analysis engines such as OCR, face detection, scene detection, etc.). Cue Points are the objects that store this temporal metadata, and it’s very often that you’ll want to search through them to create smart search driven experiences.

For example, in our video cooking recipes library, all our videos were marked with ingredients as we were using them: sugar, flour, etc. Let’s find all the strawberry recipes where we’re not using sugar.

{% highlight php %}
<?php
$cuePointItem = new KalturaESearchCuePointItem();
$cuePointItem->itemType = KalturaESearchItemType::EXACT_MATCH;
$cuePointItem->fieldName = KalturaESearchCuePointFieldName::TEXT;
$cuePointItem->searchTerm = 'adding sugar';

$notOperator = new KalturaESearchEntryOperator();
$notOperator->operator = KalturaESearchOperatorType::NOT_OP;
$notOperator->searchItems = array($cuePointItem);
// We defined a cue point item with 'adding sugar' as its search term. Then we added it to the NOT operator.

$entryNameItem = new KalturaESearchEntryItem();
$entryNameItem->searchTerm = 'strawberry';
$entryNameItem->itemType = KalturaESearchItemType::PARTIAL;
$entryNameItem->fieldName = KalturaESearchEntryFieldName::NAME;

$searchOperator = new KalturaESearchEntryOperator();
$searchOperator->operator = KalturaESearchOperatorType::AND_OP;
$searchOperator->searchItems = array($entryNameItem, $notOperator);

$searchParams = new KalturaESearchEntryParams();
$searchParams->searchOperator = $searchOperator;

$elasticsearchPlugin = KalturaElasticSearchClientPlugin::get($client);
$searchResults = $elasticsearchPlugin->eSearch->searchEntry($searchParams, null);
{% endhighlight %}

Then we searched for recipes containing strawberry with an AND condition on our previous NOT.

### Results

{% highlight json %}
{
"object":{
"id":"123456",
"name":"strawberry shortcake recipe",
"objectType":"KalturaMediaEntry"
}
}
{% endhighlight %}

## Ranges and Dates

Perhaps one of the most common searches includes searching between specific date ranges. We’ll search for all recipes created this past January, using their epoch timestamps.

{% highlight php %}
<?php
$entryNameItem = new KalturaESearchEntryItem();
$entryNameItem->searchTerm = 'recipe';
$entryNameItem->itemType = KalturaESearchItemType::EXACT_MATCH;
$entryNameItem->fieldName = KalturaESearchEntryFieldName::NAME;

$rangeItem = new KalturaESearchRange();
$rangeItem->greaterThanOrEqual = 1514764800;
$rangeItem->lessThanOrEqual = 1517443199;

$entryCreatedAtItem = new KalturaESearchEntryItem();
$entryCreatedAtItem->itemType = KalturaESearchItemType::RANGE;
$entryCreatedAtItem->fieldName = KalturaESearchEntryFieldName::CREATED_AT;
$entryCreatedAtItem->range = $rangeItem;

$searchOperator = new KalturaESearchEntryOperator();
$searchOperator->operator = KalturaESearchOperatorType::AND_OP;
$searchOperator->searchItems = array($entryNameItem, $entryCreatedAtItem);

$searchParams = new KalturaESearchEntryParams();
$searchParams->searchOperator = $searchOperator;

$elasticsearchPlugin = KalturaElasticSearchClientPlugin::get($client);
$searchResults = $elasticsearchPlugin->eSearch->searchEntry($searchParams, null);
{% endhighlight %}

### Results

{% highlight json %}
{
"object":{
"name":"pasta recipe",
"createdAt":1516097789,
"objectType":"KalturaMediaEntry"
}
}
{% endhighlight %}

## Complex Search

Now to make things interesting: what if you were looking for an entry with “pasta” in the name and 食谱 (recipe in Chinese) within the captions? Or if you were looking for “recipe” in custom metadata and wanted to highlight the results? eSearch has your back.

{% highlight php %}
<?php
$entryNameItem = new KalturaESearchEntryItem();
$entryNameItem->searchTerm = 'pasta';
$entryNameItem->itemType = KalturaESearchItemType::EXACT_MATCH;
$entryNameItem->fieldName = KalturaESearchEntryFieldName::NAME;
$entryNameItem->addHighlight = true;
{% endhighlight %}

We defined an entry item with pasta in its name.

{% highlight php %}
<?php
$captionItem = new KalturaESearchCaptionItem();
$captionItem->searchTerm = '食谱';
$captionItem->itemType = KalturaESearchItemType::PARTIAL;
$captionItem->fieldName = KalturaESearchCaptionFieldName::CONTENT;
$captionItem->addHighlight = true;
{% endhighlight %}

Then we defined a new caption item which contains recipe (Chinese) in its captions

{% highlight php %}
<?php
$metadataItem = new KalturaESearchEntryMetadataItem();
$metadataItem->searchTerm = 'recipe';
$metadataItem->itemType = KalturaESearchItemType::STARTS_WITH;
$metadataItem->metadataProfileId = 653;
$metadataItem->addHighlight = true;
{% endhighlight %}

We also created a metadata item of **profile id** 653 that starts with recipe. Notice that these three objects have no relation to one another.

{% highlight php %} 
<?php
$captionsOrMetadataOperator = new KalturaESearchEntryOperator();
$captionsOrMetadataOperator->operator = KalturaESearchOperatorType::OR_OP;
$captionsOrMetadataOperator->searchItems = array($captionItem, $metadataItem);
{% endhighlight %}

Now we’ve defined an OR condition between the caption item and the metadata item.

{% highlight php %}
<?php
$searchOperator = new KalturaESearchEntryOperator();
$searchOperator->operator = KalturaESearchOperatorType::AND_OP;
$searchOperator->searchItems = array($entryNameItem, $captionsOrMetadataOperator);
{% endhighlight %}

And then we defined an AND condition between our group and that first entry item.
Lastly, we search. 

{% highlight php %} 
<?php
$searchParams = new KalturaESearchEntryParams();
$searchParams->searchOperator = $searchOperator;
$elasticsearchPlugin = KalturaElasticSearchClientPlugin::get($client);
$searchResults = $elasticsearchPlugin->eSearch->searchEntry($searchParams, null);
{% endhighlight %}

### Results

{% highlight json %}
{
    "totalCount":2,
    "objects":[
        {
    "object":{
        "name":"pasta bolognese",
        "objectType":"KalturaMediaEntry"
    },
    "itemsData":[
        {
        "totalCount":1,
        "items":[
            {
                "line":"\u98df\u8c31",
                "startsAt":0,
                "endsAt":10000,
                "language":"Chinese",
                "captionAssetId":"0_5ifj0qhq",
                "highlight":[
                    {
                        "fieldName":"caption_assets.content.raw",
                        "hits":[
                            {
                                "value":"<em>\u98df\u8c31<\/em>",
                                "objectType":"KalturaString"
                            }
    },
{
    "object":{
        "name":"delicious pasta recipe",
        "objectType":"KalturaMediaEntry"
    },
    "highlight":[
        {
            "fieldName":"name",
            "hits":[
                {
                    "value":"delicious <em>pasta<\/em> recipe",
                    "objectType":"KalturaString"
                }
            ],
        }
    ],
    "itemsData":[
    {
        "totalCount":1,
        "items":[
            {
                "xpath":"\/* local-name()='metadata' \/* local-name()='Field1' ",
                "metadataProfileId":653,
                "metadataFieldId":668,
                "valueText":"recipe",
                "highlight":[
                    {
                    "fieldName":"metadata.value_text.raw",
                    "hits":[
                        {
                            "value":"<em>recipe<\/em>",
                            "objectType":"KalturaString"
                        }
}
{% endhighlight %} 

If you're interested in building search into your video experiences, the easy way to learn more about the eSearch API is by trying it out in the [console](https://developer.kaltura.com/console/service/eSearch). 
