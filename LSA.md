# Latent Semantic Analysis

##TL; DR
* Latent Semantic Analysis (LSA) is a [*bag of words*](Glossary.md) method of [*embedding*](Glossary.md) [*documents*](Glossary.md) into a vector space.
* Each word in our [*vocabulary*](Glossary.md) relates to a unique dimension in our vector space. For each [*document*](Glossary.md), we go through the [*vocabulary*](Glossary.md), and assign that [*document*](Glossary.md) a score for each word. This gives the [*document*](Glossary.md) a vector [*embedding*](Glossary.md).
* There are various schemes by which this scoring can be done. A simple example is to count the number of occurrences of each word in the [*document*](Glossary.md). We can also use [*IDF weighting*](Glossary.md) and [*normalisation*](Glossary.md).
* We make a [*term-document matrix (TDM)*](Glossary.md) out of our [*document*](Glossary.md) vectors. The [*TDM*](Glossary.md) defines a subspace spanned by our [*documents*](Glossary.md).
* We do a [*singular value decomposition*](https://en.wikipedia.org/wiki/Singular-value_decomposition) to find the closest rank-$k$ approximation to this subspace, where $k$ is an integer chosen by us. This rank reduction has the effect of implicitly redefining our [*document*](Glossary.md) [*embedding*](Glossary.md) so that it depends on $k$ features, which are linear combinations of the original scores for words. This output is the same as that for a [principal component analysis](https://en.wikipedia.org/wiki/Principal_component_analysis) with $k$ principal components.
* We can then define similarity between our [*documents*](Glossary.md) using [*cosine similarity*](Glossary.md): the cosine of the angle between their vectors in the rank-$k$ subspace.

## Motivation

We want to find a way of [*embedding*](Glossary.md) [*documents*](Glossary.md) in a vector space in way that encodes their conceptual content. Latent Semantic Analysis (LSA) gives us a way of doing this using standard Linear Algebra.

Warning: this page includes both mathematical formulae and mathematical concepts. I've tried to keep it as simple as possible and to use examples where I can, but doubtless it can be improved upon.

## Assumptions

LSA is a [*bag of words*](Glossary.md) model, so the order of the words in a [*document*](Glossary.md) makes no difference to how it is [*embedded*](Glossary.md) in our vector space. Additionally, since every [*document*](Glossary.md) is given a single vector representation there is an implicit assumption that each document is 'about' one thing - at least, the model will work best in circumstances where [*documents*](Glossary.md) are likely to be about a handful of topics at most. This can often be achieved by defining [*documents*](Glossary.md) to be short pieces of text, for example defining them to be individual sentences.

## The vector space

The vector space is defined in terms of the [*vocabulary*](Glossary.md). Each and every word in the [*vocabulary*](Glossary.md) has its own distinct orthogonal dimension.

For example, if our [*corpus*](Glossary.md) is the Dr Seuss story "*Green Eggs and Ham*", then (after making lower case, removing [*stopwords*](Glossary.md), and [*stemming*](Glossary.md)) our [*vocabulary*](Glossary.md) is
>boat, box, car, dark, eat, egg, fox, goat, good, green, ham, hous, mous, rain, sam, train, tree

Our vector space then has 17 dimensions, each relating to one of these terms. If our [*documents*](Glossary.md) are sentences from the story, each of them will be describable by an 17-dimensional vector.

Notice that this metholodogy implicitly assumes that the 17 words in the vocabulary are orthogonal to one another, which best describes a situation where the presence of a given word in a [*document*](Glossary.md) is independent from the presence of the other words in the [*vocabulary*](Glossary.md). In practice, in the case of "*Green Eggs and Ham*", I expect we'd find that "*green*", "*egg*", and "*ham*" co-appear to a large degree. 

## Counting words

With our vector space defined, we now need a method by which we can determine each [*document*](Glossary.md)'s position along each of the axes. Recall that each axis represents a specific word in the [*vocabulary*](Glossary.md). So for each [*document*](Glossary.md), we need only find a way of giving it a score for each word in the [*vocabulary*](Glossary.md) and our [*embedding*](Glossary.md) will be done.

The simplest way of doing this is just to go through each [*document*](Glossary.md) and count the number of occurrences of each [*vocabulary*](Glossary.md) word.

To continue our "*Green Eggs and Ham*" example, the line
> I do not like green eggs and ham

after making lower case, removing [*stopwords*](Glossary.md), and [*stemming*](Glossary.md), becomes
>{green, egg, ham}

Counting the number of occurrences of each [*vocabulary*](Glossary.md) word would give an [*embedding*](Glossary.md) $(0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0)$ (taking the dimensions in alphabetical order of the words in the [*vocabulary*](Glossary.md)). Similarly, the line
> Eat them! Eat them! Here they are!

becomes
> {eat, eat}

and gets [*embedded*](Glossary.md) as $(0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0)$.

## Beyond counting

There are more advanced, better ways of [*embedding*](Glossary.md) [*documents*](Glossary.md) in our vector space, called "[*weighting schemes*](Glossary.md)". Typically these different schemes vary in three ways: how they take term frequency into account, how they take [*inverse document frequency*](Glossary.md) into account, and whether they [*normalise*](Glossary.md).

###Term frequency
This covers whether how the weighting scheme deals with the frequency of occurrence of each word in the [*vocabulary*](Glossary.md). Two possibilities we've investigated are
* just counting the frequency of terms; and
* scoring 1 if a term is used and 0 if it isn't.

This latter, "Boolean" scheme is what we use when doing LSA on Parliamentary Questions: the fact that a PQ mentions the word "prison" more than once (for example, asking for the same statistic about multiple named prisons) doesn't make it more about prisons.

###[Inverse document frequency](Glossary.md)
All words are not equal in information content, even once we have taken out [*stopwords*](Glossary.md). Words that appear in nearly all [*documents*](Glossary.md) in our [*corpus*](Glossary.md) will be unsurprising when we see them; their appearance in a [*document*](Glossary.md) will tell us very little about it. The appearance of a rare word in a [*document*](Glossary.md), however, may be very decisive in helping us discern its information content.

For example, the Ministry of Justice does not get many Parliamentary Questions about Britain leaving the EU. If we see the relatively rare term "*Brexit*" in a question it's a good guide to what the question is about. On the other hand, there are lots of questions about various aspects of prisons, and so the existence of the word "*prison*" in a question tells us less about its specific topical content.

Notice that we consider how rare or common the word in question is within the [*corpus*](Glossary.md) under consideration, not upon how rare or common it is in English in general. Context is everything in language: the appearance of the word "*lobster*" would not be as surprising in a headline from fishing news website [Undercurrent](https://www.undercurrentnews.com/) as it would be in a headline from football website [When Saturday Comes](http://www.wsc.co.uk/).

###[Normalisation](Glossary.md)

At some point after applying one or both of the above schemes we can choose whether or not to [*normalise*](Glossary.md) our [*document*](Glossary.md) vector so that it has unit length.

The main advantage of this step is to reduce computation time in the case where we are going to use [*cosine similarity*](Glossary.md) as our similarity measure between [*documents*](Glossary.md). If we normalise our [*document*](Glossary.md) vectors they have length one and, since the cosine rule gives $$ \frac{\mathbf{a}.\mathbf{b}}{|\mathbf{a}||\mathbf{b}|} = \cos \theta, $$ we can calculate the cosine of the angle between [*document*](Glossary.md) vectors just using the dot product. In R, at least, and I suspect in many coding languages, dot products between vectors are optimised to be very quick to calculate.

## The subspace defined by our [*documents*](Glossary.md)

So now we've embedded our [*documents*](Glossary.md) in our vector space. We can go further and define the subspace spanned by our documents by taking each of the [*document*](Glossary.md) vectors. We do this by defining a [*term-document matrix* (*TDM*)](Glossary.md): the row vectors of this matrix are our [*document*](Glossary.md) vectors, and the columns represent the words in the [*vocabulary*](Glossary.md).

The rank $r$ of this matrix (equivalently the rank of the subspace spanned by our [*corpus*](Glossary.md)) will be bounded above by whichever is the smaller out of the size of the [*vocabulary*](Glossary.md) and the number of [*documents*](Glossary.md). This value $r$ can be thought of as the number of parameters we would need to be able to fully describe any of our [*documents*](Glossary.md) (under this [*weighting scheme*](Glossary.md)).

What if we think that we could describe our [*documents*](Glossary.md) with fewer parameters than this? What if we think that there are really $k$ "hidden" parameters that can sufficiently describe any of our [*documents*](Glossary.md)?

Amazingly, thanks to the wonders of linear algebra, we can use our [*term-document matrix*](Glossary.md), representing the rank-$r$ description of our documents due to our original [*weighting scheme*](Glossary.md), to generate the unique rank-$k$ description of our documents that is "closest" to the original description (closest in the sense of "least-squares"). That is, we can automatically generate an [*embedding*](Glossary.md) of our [*documents*](Glossary.md) that
* is of rank $k$; and
* 'throws away' the least information from our original [*embedding*](Glossary.md), in some sense.



