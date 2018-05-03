# Neural Network models

## TL; DR

* What we here call Neural Network models refers to a whole set of methods for [*embedding*](Glossary.md#embedding) words (and also sometimes [*documents*](Glossary.md#document)) into a vector space, by the use of a neural network. Examples include Word2Vec, Doc2Vec, and FastText.
* There are a wide variety of such methods; for example Word2Vec is actually not one but two separate methods (CBOW and skip-gram).
* The word [*embeddings*](Glossary.md#embedding) can either be trained on the [*corpus*](Glossary.md#corpus) of interest, or can be downloaded as a pre-trained set of vectors trained on a large [*corpus*](Glossary.md#corpus) e.g. Wikipedia. Which is more appropriate will depend on your aims.
* The [*embeddings*](Glossary.md#embedding) can be of any number of dimensions; Word2Vec guidance is vague on this and suggests between 100 and 1000. Typically more dimensions = greater quality encoding, but there will be some limit beyond which you'll get diminishing returns. We typically use 200 or 300.
* The output vectors encode both semantic and syntactic meaning, and we can do some algebra with them. For example with the Word2Vec pretrained vectors we get **France** + **Berlin** - **Germany** = **Paris**, and also **faster** + **warm** - **fast** = **warmer** (where **term** is the vector representing "*term*", additions and subtractions are as usual with vectors, and the equals operator in this case means "closest pre-defined vector", e.g. **Paris** is the closest predefined vector to the vector we get when doing the sum **France** + **Berlin** - **Germany**).
* Either directly, or by combining word vectors in some way, we can get [*embeddings*](Glossary.md#embedding) for our [*documents*](Glossary.md#document), which means we can do [*Search*](Search.md) or find [*Topics*](Topics.md) in the usual manner.
* We need to do some testing on our results to make sure that they are good. This is a mix of automated tests and simply eyeballing the output to make sure it looks ok.

## Motivation

We want to find a way of [*embedding*](Glossary.md#embedding) [*documents*](Glossary.md#document) in a vector space in way that encodes their conceptual content. Neural network models do this in a way that is claimed to be better than [Latent Semantic Analysis](LSA.md), and is certainly fancier.

## The models

There are three main models using this technique that I'm aware of: Word2Vec, Doc2Vec, and fastText. I will concentrate mostly on Word2Vec here, as the others are to some extent generalisations of it. All three models allow you to generate vector [*embeddings*](Glossary.md#embedding) from your [*corpus*](Glossary.md#corpus).

## Vector arithmetic

One of the main boasts about these types of [*embeddings*](Glossary.md#embedding) is they seem to magically encode meaning in some deep and profound way. This can be seen by doing arithmetic with the word vectors.

We can of course add and subtract vectors in the usual way, so all that is needed to make sense of the results is to define the equals operator such that

**A** + **B** = **C**

is understood to mean

 >*C* is the word in our [*vocabulary*](Glossary.md#vocab) whose vector **C** is closest to the vector you get when you add **A** and **B**

With this definition, and using the standard downloadable Word2Vec vectors pre-trained on Google News we get that, for example,

**France** + **Berlin** - **Germany** = **Paris**

and

**faster** + **warm** - **fast** = **warmer** 

so you can see that the [*embeddings*](Glossary.md#embedding) have encoded semantic concepts like capital cities of countries, and grammatical concepts like [the comparative](https://en.wikipedia.org/wiki/Comparative).

Not that this sort of arithmetic is particularly directly useful when doing [search](Search.md) or findings [topics](Topics.md), of course. But perhaps it provides some credibility to the model. At worst it's a neat trick.

## Pre-trained vectors

In some cases you don't want to actually run your own vector [*embeddings*](Glossary.md#embedding). The main reason for this (barring technical or technological barriers) would be that you doubt you have enough data to successful encode your words. In particular, you don't think there are enough example of various pairs of synonyms for the model to recognise them as having the same conceptual meaning. A model can only recognise, for example, "*jail*" and "*prison*" as having similar meanings if they appear in enough sentences with similar other words.

If you are in this situation, you can use pre-trained word vectors instead. There are lists [here](http://ahogrammer.com/2017/01/20/the-list-of-pretrained-word-embeddings/) and [here](https://github.com/3Top/word2vec-api), for example or search yourself. The idea is that, assuming their training [*corpus*](Glossary.md#corpus) was sufficiently large and general in scope, pre-trained [*embeddings*](Glossary.md#embedding) will represent general English in some sense. The standard 300-dimensional Word2Vec [*embeddings*](Glossary.md#embedding) trained on Google News have a [*vocabulary*](Glossary.md#vocab) of ~3 million words, for example, and encode a lot of syntactic and semantic information.

However, a word of warning: a lot of these pre-trained vector sets are American, and are trained on [*corpuses*](Glossary.md#corpus) using mostly US English. This can cause problems when trying to use British English.

Additionally, and related, your own [*corpus*](Glossary.md#corpus) of interest may contain language specific to its own realm, e.g. slang or technical terms. When dealing with prison reports, it was important for us to derive our own [*embeddings*](Glossary.md#embedding) because there is a lot of terminology specific to the prison system. To choose one example, the word "*spice*" needs to be [*embedded*](Glossary.md#embedding) so that it is similar to "*NPS*" and "*cannabinoid*". Had we used pre-trained word vectors, it would have been seen as similar to "*cumin*" and "*cinnamon*" instead.

## Training your own

The alternative to using pre-trained vectors is of course training your own. In practice we have done this using Python and the excellent `gensim` library.

When training your own vectors you have to make a lot of choices: which model to use, which of the resulting submodels (see below for some detail) that you then use, and how to parametrise that model (each model comes with a lot of parameters). In particular, regardless of other choices, you need to decide how many dimensions you want your vector space to be. The standard Word2Vec pre-trained vectors, as mentioned above, have 300 dimensions. We have tended to use 200 or fewer, under the rationale that our [*corpus*](Glossary.md#corpus) and [*vocabulary*](Glossary.md#vocab) are much smaller than those of Google News, and so we need fewer dimensions to represent them.

You should of course do some testing to help improve your chosen mix of parameters and meta-parameters.

## The Word2Vec models

There are actually two Word2Vec models: CBOW (Continuous Bag-of-Words) and Skip-gram. I won't go into too much detail about how they work, because you can find plenty of description online (e.g. [here](http://mccormickml.com/2016/04/19/word2vec-tutorial-the-skip-gram-model/) and [here](https://medium.com/scaleabout/a-gentle-introduction-to-doc2vec-db3e8c0cce5e)). But I think it's important to give a brief overview.

Both models work by trying to use a shallow neural network to do some prediction of word co-occurrences, using the [*corpus*](Glossary.md#corpus) of interest as data to train the model. Let's look at an example piece of text
> we can have lots of good fun that is funny

(taken from The Cat in the Hat, by Dr Seuss). If we focus on the word "*good*", we can see that it is preceded by the four words *can*, *have*, *lots*, *of*, and followed by the four words *fun*, *that*, *is*, *funny*. This idea of words existing in the centre of a sliding window of the words around them is central to Word2Vec. In this example I have chosen a window size of 4 words, but in practice we can set this to whatever we like.

The major distinction between CBOW and skip-gram models is in the task that the neural network is given. In the case of CBOW, the task is to predict the focal word (*good*) from the context ({*can*, *have*, *lots*, *of*; *fun*, *that*, *is*, *funny*}). Conversely, for skip-gram, the task is to predict the context words ({*can*, *have*, *lots*, *of*; *fun*, *that*, *is*, *funny*}) from the focal word *good*.

In practice we've found the two methods to produce broadly similar results. According to one of the inventors of Word2Vec, Tomas Mikolov,
> Skip-gram: works well with small amount of the training data, represents well even rare words or phrases.
CBOW: several times faster to train than the skip-gram, slightly better accuracy for the frequent words

So there you go. Either way, once we've trained a shallow neural network to do this amazing predictive feat, we don't actually use it for that. Rather, in order to be able to do this magical thing, the neural network creates a series of high-dimensional (the dimensionality is the same as the number of nodes in the single hidden layer of the network) vectors for each word in the [*vocabulary*](Glossary.md#vocab). It is these vectors that we want: they are our [*embedding*](Glossary.md#embedding)

## Doc2Vec and fastText

### Doc2Vec

Doc2Vec uses the same process as Word2Vec, but it also uses the identity of the [*document*](Glossary.md#document) from which the context and focal words are taken as input. There are two models here too, DM (Distributed Memory) and DBOW (Distributed Bag-of-Words). DM is analogous to CBOW above, while DBOW is related to skip-gram (I know, I know, it's unsatisfying that DM and CBOW are related, and DBOW and skip-gram, rather than having CBOW and DBOW be related as you'd expect).

The idea in DM is to build a neural network that can predict a focal word from its context and the [*document*](Glossary.md#document) that it's in. Thus the information encoded by the [*document*](Glossary.md#document) vector is the extra stuff that you might need to know to predict a word from its context *given what the [*document*](Glossary.mnd) is about*.

From what I have been able to glean online, DBOW tries to predict words randomly sampled from the [*document*](Glossary.md#document) knowing only the identity of the [*document*](Glossary.md#document). I am not sure how this makes sense in practice, since it seems to me that the input data includes the exact frequency of each word within each [*document*](Glossary.md#document) which would be the best predictor, but I've obviously missed something.

In practice, Mikolov (yes, him again) claims that a combination of both algorithms should be used, but elsewhere I've seen it claimed that DM should be superior.

For both Doc2Vec methods you can also get the model to output word vectors (at least in gensim).

### fastText

Whereas Word2Vec and Doc2Vec were created by Google, fastText is the brainchild of Facebook. Oh, also of that Mikolov chap again, after he (presumably) got poached.

As far as I know (which isn't much) fastText is an extension of Word2Vec in which words are broken down into their constituent parts, and these parts are used as input in addition to the words. So for example, even if we didn't know what "psychopharmacotherapy" meant we might be able to guess from the bits of words that make it up: "psycho", "pharmaco", "therapy".

Of course breaking up the words in this way makes for a much [*vocabulary*](Glossary.md#vocab), but apparently fastText does some clever things to run quickly. I've never actually tried it because the pre-trained vectors were to large that they blew up my computer.

## From words to [*documents*](Glossary.md#document)

Once we've got our word [*embeddings*](Glossary.md#embedding) we need to use them to [*embed*](Glossary.md#embedding) our [*documents*](Glossary.md#document). If we're using Doc2vec this is done automatically. Otherwise, however, we have to choose how we will do this.

The method we have thus far used has been to calculate the [*IDF*](Glossary.md#idf) scores for each word in the [*vocabulary*](Glossary.md#vocab), and then [*embed*](Glossary.md#embedding) each [*document*](Glossary.md#document) as an average of the vectors for the words within it, weighted by their [*IDF*](Glossary.md#idf) scores.

## Testing

Once you have generated your [*embeddings*](Glossary.md#embedding) you need to see if they make any sense. It is always a good idea to quality assure a model by testing, but that is especially the case here when we our model comes by training up a black box to do a task, and then using some by-product of that training to do what we actually want to do...

The difficulty is knowing what to do to test the model. There are four types of tests that we currently do, covering a mix of testing the [*document*](Glossary.md#document) [*embeddings*](Glossary.md#embedding) and the word [*embeddings*](Glossary.md#embedding) that make them up.

The beauty of having a well-defined set of tests is that we are able to use them to compare between models, and thus navigate our way better through the forest of different options (CBOW, skip-gram, DBOW, DM, plus parameter choices for all of them). We can search the parameter (and meta-parameter) space, compute the test results, and use the model that gives us the best answers.

### Self-similarity
 The first test we do is the simplest, and test our ability to do [search](Search.md) on our [*corpus*](Glossary.md#corpus). We simply take each [*document*](Glossary.md#document) as as search phrase, and see if we get that [*document*](Glossary.md#document) back as most similar.

 It should be noted that (depending on how we [*embed*](Glossary.md#embedding) our search phrase) the way we construct our [*document*](Glossary.md#document) [*embeddings*](Glossary.md#embedding) above means that we are pretty much guaranteed 100% (barring noise effects due to multiple identical [*documents*](Glossary.md#document) in the [*corpus*](Glossary.md#corpus)) on any Word2Vec model in this test (although this is not true of Doc2Vec), so it's not usable to compare between models in this way. Rather we use it as a threshold: if a model doesn't get over 95% on this test we wouldn't want to use it.

 ### Semilar test
 We found a [*corpus*](Glossary.md#corpus) of paired sentences, called the Semilar Corpus, [here](http://deeptutor2.memphis.edu/Semilar-Web/public/semilar-corpus.html). Each pair of sentences is semantically related but syntactically distinct (different words, same meaning), for example
 > The economy, nonetheless, has yet to exhibit sustainable growth.

 and
 > But the economy hasn't shown signs of sustainable growth.

We include this [*corpus*](Glossary.md#corpus) with the rest of our [*documents*](Glossary.md#document) when training the model, and then we test the model by giving it a sentence from the Semilar Corpus and seeing if it can find the other sentence as being very similar.

Typically this is how we determine between models.

### Pair similarity test

The above two tests are more important because they capture some element of the actual use case of our model. However, it is also interesting to see how our model does when comparing meanings of actual words.

We do this by doing some word arithmetic like that seen above. We've got a big set of quartets of words of the form
> {work, works, walk, walks}

or
> {thinking, thought, writing, wrote}

or various other combinations of semantic and syntactic variation. We go through this massive list, find examples where we have all four words in the list, and then do a calculation like

**word_2** - **word_1** + **word_3** = **V**

We then see if **word_4** is one of the closest vectors in our set to the vector **V**, "closest" here meaning something like "in the top 10".

Unfortunately in practice we haven't yet trained a model on a sufficiently large [*corpus*](Glossary.md#corpus) for this to work very well - the model simply doesn't see enough examples of the words in a quartet for it to encode these subtle combinations of meaning. But we expect it to become more valid if our [*corpuses*](Glossary.md#corpus) increase in size.

### Looking at the results

Our final test is also the least sophisticated: have a look at the results. This means both look at what comes out as 'most similar' words to a given word of interest (does "*spice*" come out as being similar to "*NPS*"?) and looking at how the actual [*document*](Glossary.md#document) search functionality is working.

Obviously this sort of testing is harder to do systematically, but in the end it's the most important thing because it best reflects the purpose of all of this work.