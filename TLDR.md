# TL;DR collection

## Search

* People want to search through a big [*corpus*](Glossary.md) to find the [*documents*](Glossary.md) most relevant to their interests.
* If we [*embed*](Glossary.md) our [*documents*](Glossary.md) into a vector space we can then choose a metric or similarity measure of our choice (often [*cosine similarity*](Glossary.md)) to get similarity scores between [*documents*](Glossary.md) and any search phrase (which we also [*embed*](Glossary.md)).
* With these similarity scores we can return the *N* most similar [*documents*](Glossary.md), or those above a certain level of similarity, or list [*documents*](Glossary.md) in similarity order.
* Choosing a methodology for [*embedding*](Glossary.md) is non-trivial; there is no one-size-fits-all best practice and a frustrating (for me, at least) lack of information theoretic rigour about what constitutes a good or sensible choice.
* The choice of [*embedding*](Glossary.md) methodology will be influenced by what your users will be interested in. You will need to do some [feature selection (click to read about that)](FeatureSelection.md).
* Following [feature selection](FeatureSelection.md), some methodologies we've had success with are [Latent Semantic Analysis](LSA.md) and [Neural Network models like Word2Vec and Doc2Vec](NNmodels.md).
* All methodologies (that we've tried) are subject to improvements using a lot of sleight-of-hand and parameter tweaking (some of this is part of [feature selection](FeatureSelection.md) and some is tweaking model parameters).

## Topics

* We want to be able to automatically discover the hidden topics that our [*corpus*](Glossary.md) covers, and having done this we want to be able to say which topic (or mix of topics) is contained in each [*document*](Glossary.md).
* There are various methods by which these things can be achieved.
* If you've got enough documents that are already tagged with their topics you could use some sort of supervised machine learning technique, e.g. naive Bayes. We've never been in this situation, so we'll focus on unsupervised machine learning techniques.
* Latent Dirichlet Allocation is often mentioned in connection with this; we've never got it to work.
* If you've already [*embedded*](Glossary.md) your documents in a vector space with some measure of distance you can use [*clustering*](Glossary.md) algorithms on the [*document*](Glossary.md) vectors and call the resultant clusters your topics.
* For the unsupervised machine learning techniques, typically you have to define some parameter such as the number of topics, or the density of points in your vector space to define a cluster.
* Where topics are derived via an unsupervised machine learning methods their meanings can be hard to define in an appropriate, semantically-meaningful, human-understandable way.

## Latent Semantic Analysis

* Latent Semantic Analysis (LSA) is a [*bag of words*](Glossary.md) method of [*embedding*](Glossary.md) [*documents*](Glossary.md) into a vector space.
* Each word in our [*vocabulary*](Glossary.md) relates to a unique dimension in our vector space. For each [*document*](Glossary.md), we go through the [*vocabulary*](Glossary.md), and assign that [*document*](Glossary.md) a score for each word. This gives the [*document*](Glossary.md) a vector [*embedding*](Glossary.md).
* There are various schemes by which this scoring can be done. A simple example is to count the number of occurrences of each word in the [*document*](Glossary.md). We can also use [*IDF weighting*](Glossary.md) and [*normalisation*](Glossary.md).
* We make a [*term-document matrix (TDM)*](Glossary.md) out of our [*document*](Glossary.md) vectors. The [*TDM*](Glossary.md) defines a subspace spanned by our [*documents*](Glossary.md).
* We do a [*singular value decomposition*](https://en.wikipedia.org/wiki/Singular-value_decomposition) to find the closest rank-*k* approximation to this subspace, where *k* is an integer chosen by us. This rank reduction has the effect of implicitly redefining our [*document*](Glossary.md) [*embedding*](Glossary.md) so that it depends on *k* features, which are linear combinations of the original scores for words. This is conceptually broadly similar to [principal component analysis](https://en.wikipedia.org/wiki/Principal_component_analysis) with *k* principal components (for the exact relationship, [see e.g. here](https://intoli.com/blog/pca-and-svd/)).
* We can then define similarity between our [*documents*](Glossary.md) using [*cosine similarity*](Glossary.md): the cosine of the angle between their vectors in the rank-*k* subspace.
* To choose *k* we have so far relied on good old trial and error. Although there are doubtless statistical measures for how "good" a value of *k* is (along the lines of plotting some loss of information and looking for an elbow in the plot), we have instead focussed on investigating what happens in the actual tool.

## Latent Dirichlet Allocation (LDA)

* Latent Dirichlet Allocation is a probabilistic method for [*Topic*](Topics.md) Modelling.
* We have to choose the number of topics *k* that we want to 'discover' in our [*corpus*](Glossary.md).
* The results then find these hidden topics, and give us the words that make up each topic, in the form of a probability distribution over thje [*vocabulary*](Glossary.md) for each topic.
* They also give us the topical mix for each [*document*](Glossary.md), in the form of a probability distribution over the topics for each [*document*](Glossary).
* Unfortunately we have encountered two major problems with the results when we've tried this. These problems may be with our implementations rather than with the method, but we have tried on different data (and colleagues from another department independently had the same problems).
* The main problem is that the assignment of topics to [*document*](Glossary.md) does not appear to be sensible - we found that  [*documents*] with identical wording were being stated as having wildly different topical content.
* The secondary problem is that the topics themselves are extremely challenging to describe in a semantically-meaningful way; rather they often seem to be arbitrary lists of words whose co-appearance in [*documents*](Glossary.md) is not indicative of any thematic commonality.
* We have stopped trying to implement LDA for the moment.
