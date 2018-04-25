# Topics

## TL; DR

* We want to be able to automatically discover the hidden topics that our [*corpus*](Glossary.md) covers, and having done this we want to be able to say which topic (or mix of topics) is contained in each [*document*](Glossary.md).
* There are various methods by which these things can be achieved.
* If you've got enough documents that are already tagged with their topics you could use some sort of supervised machine learning technique, e.g. naive Bayes. We've never been in this situation, so we'll focus on unsupervised machine learning techniques.
* Latent Dirichlet Allocation is often mentioned in connection with this; we've never got it to work.
* If you've already [*embedded*](Glossary.md) your documents in a vector space with some measure of distance you can use [*clustering*](Glossary.md) algorithms on the [*document*](Glossary.md) vectors and call the resultant clusters your topics.
* For the unsupervised machine learning techniques, typically you have to define some parameter such as the number of topics, or the density of points in your vector space to define a cluster.
* Where topics are derived via an unsupervised machine learning methods their meanings can be hard to define in an appropriate, semantically-meaningful, human-understandable way.

## Motivation

In most [*corpusses*](Glossary.md) it is not the case that each [*document*](Glossary.md) is about something totally different. Rather, there are usually a few underlying topics which cover the content of the [*corpus*](Glossary.md). We would like to be able to
* automatically discover what these underlying topics are; and then
* say which topic (or mix of topics) is contained in each [*document*](Glossary.md).

This question can actually be somewhat more general than just determining the topical content of the text. For example, if we take emails to have only one of two topics, 'spam' or 'ham', then creating a spam filter is an example of a problem in this area.

## Supervised or unsupervised

If you are lucky, you will have a large [*corpus*](Glossary.md) of texts, the topical content of which is already tagged. Our spam filter example above might be of this nature. Similarly, some departments have a taxonomy for parliamentary questions that details what team they are to be answered by depending on their topical content.

The reason that having topical tags already assigned to your [*corpus*](Glossary.md) is fortunate is that it enables you to use supervised machine learning techniques such as naive Bayes, to classify future [*documents*](Glossary.md) in a way comparable to those in the existing data set. It also means that questions about the number, size, and definition of topics are already answered.

Unfortunately, we have not experienced this happy state of affairs (which might be why we think it's a happy state of affairs - the grass is always greener). Instead, we have so far been restricted to the situation where our [*documents*](Glossary.md) are unclassified, and we have to determine the topics all by ourselves. This leaves us in the world of unsupervised machine learning, and particularly trying either Latent Dirichlet Allocation (LDA) or using [*clustering*](Glossary.md) algorithms.

## Latent Dirichlet Allocation (LDA)

In common with some of the [*clustering*](Glossary.md) algorithms below, for this method we need to define the number *k* of topics in our [*corpus*](Glossary.md).

LDA is a probabilistic method. For each [*document*](Glossary.md) the results give us a mix of topics that make up that [*document*](Glossary.md). To be precise, we get a probability distribution over the *k* topics for each [*document*](Glossary.md). Each word in the [*document*](Glossary.md) is attributed to a particular topic with probability given by this distribution.

Topics themselves are defined as probability distributions over the [*vocabulary*](Glossary.md). So our results are two sets of probability distributions:
* The set of distributions of topics for each [*document*](Glossary.md)
* The set of distributions of words for each topic.

The following diagram shows how this might work for three topics and 16 words in the [*vocabulary*](Glossary.md). The results for a particular [*document*](Glossary.md) are the first graph, showing the mix of topics within it. Each topic is itself a probability distribution over words in the [*vocabulary*](Glossary.md).

![Example SVD from rank 2 to rank 1](LDAresults.png)

The model is Bayesian, and doesn't admit zero probabilities either for the topic distributions or for the word distributions. This means that in every [*document*](Glossary.md) each topic has a non-zero probability, and in every topic each word in the [*vocabulary*](Glossary.md) has a non-zero probability. However, these probabilities can be vanishingly small. Indeed, the model is set up so as to try and encourage most of the probabilities to be very close to zero: we want results that suggest each [*document*](Glossary.md) is made up a small number of topics, and each topic is primarily composed of a small number of main words.


