# Search

## TL;DR

* People want to search through a big [*corpus*](Glossary.md) to find the [*documents*](Glossary.md) most relevant to their interests
* If we [*embed*](Glossary.md) our [*documents*](Glossary.md) into a vector space we can use the metric of our choice to determine similarity between [*documents*](Glossary.md) and any given search phrase (which we also [*embed*](Glossary.md)).
* Choosing a methodology for [*embedding*](Glossary.md) is non-trivial; there is no one-size-fits-all best practice and a frustrating (for me, at least) lack of information theoretic rigour about what constitutes a good or sensible choice.
* The choice of [*embedding*](Glossary.md) methodology will be influenced by what your users will be interested in. You will need to do some [feature selection (click to read about that)](FeatureSelection.md).
* Following [feature selection](FeatureSelection.md), some methodologies we've had success with are [Latent Semantic Analysis](LSA.md) and [Neural Network models like Word2Vec and Doc2Vec](NNmodels.md).
* All methodologies (that we've tried) are subject to improvements using a lot of sleight-of-hand and parameter tweaking (some of this is part of [feature selection](FeatureSelection.md) and some is tweaking model parameters).

## Motivation

When people have a large [*corpus*](Glossary.md), they often desire the ability to rapidly locate the [*documents*](Glossary.md) most relevant to their interest.

Natural Language Processing techniques can give the ability to use the words within each [*document*](Glossary.md) as a way of automatically allowing users to do this, by searching for a phrase or set of words and returning the [*documents*](Glossary.md) most related to this.

## The problem with language

As linguists and poets will tell you, language is messy (at least, I will claim that's what they said regardless of the words they use). To mention just a few problems, it can be riddled with synonyms (where different words represent a similar concept, e.g. *fair* and *just*), or homonyms (where the same word represents multiple concepts, e.g. *fair*, or *just*), and that's before we factor in irony or sarcasm. Given that it can be hard to pin down the meaning of any single sentence in a precise way, how can we say which of the [*documents*](Glossary.md) in our [*corpus*](Glossary.md) are most similar to a given phrase?

## The solution

Since language is hard, we dodge the problem by instead translating it into something that's easy: geometry (Editor's note: I am being glib - in fact bitter personal experience tells me that linear algebra is not in fact easy).

For centuries Clever People have established rigorous foundations and proven theorems in the realm of linear algebra, meaning that well-defined statements can be made about such fantastical things as geometries in spaces with thousands of dimensions. In particular, we can easily define [rigorous ways of measuring distances between points](https://en.wikipedia.org/wiki/Metric_space).

All we need to do to make use of this fantastic free set of concepts is to somehow turn our [*documents*](Glossary.md) into vectors in some vector space. Then we can define an appropriate metric to judge how close or far apart any two of them are. Then whenever the user enters a search phrase, we [*embed*](Glossary.md) it in the same vector space, and we can return all of the [*documents*](Glossary.md) that are "close enough" to our search phrase to be relevant according to some threshold, or can order documents by their relevance.

So: how do we turn our [*documents*](Glossary.md) into vectors?

## This isn't a solution

As you may have noticed, the "solution" offered above simply begs the question, since we have simply moved from
> how can we say which of the [*documents*](Glossary.md) in our [*corpus*](Glossary.md) are most similar to a given phrase?

to
> how do we [*embed*](Glossary.md) [*documents*](Glossary.md) into a vector space?

For this [*embedding*](Glossary.md) to be meaningful and worthwhile, and for the results to be sensible, we require it to somehow encode enough information on what the sentence is about (so that [*documents*](Glossary.md) that we think of as having similar meaning are [*embedded*](Glossary.md) near to one another in the vector space with respect to our chosen metric).

So all we've done is restated the problem above about being able to rigorously define the information in a particular [*document*](Glossary.md).

## Methods for [*embedding*](Glossary.md)

Because of this philosophical difficulty, there is not a single true way of [*embedding*](Glossary.md) [*documents*](Glossary.md) in a vector space, any more than there is a single true definition of what a [*document*](Glossary.md) means relative to other [*documents*](Glossary.md). Instead, the method you should use will depend on what you want to capture about each [*document*](Glossary.md). [This is called feature selection, and you can read about it here](FeatureSelection.md). Additionally, your choice will no doubt depend upon your own technological preferences, constraints, and biases.

Some models that we've used are [Latent Semantic Analysis](LSA.md), and [Neural Network models like Word2Vec and Doc2Vec](NNmodels.md) (click to read about them). In all of our use cases, a surprising amount of value can suddenly be added to the model following small changes to [feature selection](FeatureSelection.md) or to model parameters. This is not reassuring from a Quality Assurance perspective.