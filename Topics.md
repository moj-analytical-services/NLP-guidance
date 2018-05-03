# Topics

## TL; DR

* We want to be able to automatically discover the hidden topics that our [*corpus*](Glossary.md#corpus) covers, and having done this we want to be able to say which topic (or mix of topics) is contained in each [*document*](Glossary.md#document).
* There are various methods by which these things can be achieved.
* If you've got enough [*documents*](Glossary.md#document) that are already tagged with their topics you could use some sort of supervised machine learning technique, e.g. naive Bayes. We've never been in this situation, so we'll focus on unsupervised machine learning techniques.
* Latent Dirichlet Allocation is often mentioned in connection with this; we've never got it to work.
* If you've already [*embedded*](Glossary.md#embedding) your [*documents*](Glossary.md#document) in a vector space with some measure of distance you can use [*clustering*](Glossary.md#cluster) algorithms on the [*document*](Glossary.md#document) vectors and call the resultant [*clusters*](Glossary.md#cluster) your topics.
* For the unsupervised machine learning techniques, typically you have to define some parameter such as the number of topics, or the density of points in your vector space to define a [*cluster*](Glossary.md#cluster).
* Where topics are derived via an unsupervised machine learning methods their meanings can be hard to define in an appropriate, semantically-meaningful, human-understandable way.

## Motivation

In most [*corpusses*](Glossary.md#corpus) it is not the case that each [*document*](Glossary.md#document) is about something totally different. Rather, there are usually a few underlying topics which cover the content of the [*corpus*](Glossary.md#corpus). We would like to be able to
* automatically discover what these underlying topics are; and then
* say which topic (or mix of topics) is contained in each [*document*](Glossary.md#document).

This question can actually be somewhat more general than just determining the topical content of the text. For example, if we take emails to have only one of two topics, 'spam' or 'ham', then creating a spam filter is an example of a problem in this area.

## Supervised or unsupervised

If you are lucky, you will have a large [*corpus*](Glossary.md#corpus) of texts, the topical content of which is already tagged. Our spam filter example above might be of this nature. Similarly, some departments have a taxonomy for parliamentary questions that details what team they are to be answered by depending on their topical content.

The reason that having topical tags already assigned to your [*corpus*](Glossary.md#corpus) is fortunate is that it enables you to use supervised machine learning techniques such as naive Bayes, to classify future [*documents*](Glossary.md#document) in a way comparable to those in the existing data set. It also means that questions about the number, size, and definition of topics are already answered.

Unfortunately, we have not experienced this happy state of affairs (which might be why we think it's a happy state of affairs - the grass is always greener). Instead, we have so far been restricted to the situation where our [*documents*](Glossary.md#document) are unclassified, and we have to determine the topics all by ourselves. This leaves us in the world of unsupervised machine learning, and particularly trying either [*Latent Dirichlet Allocation (LDA)*](LDA.md) or using [*clustering*](Glossary.md#cluster) algorithms.

## [Latent Dirichlet Allocation (LDA)](LDA.md)

[There is a full page on LDA, and our problems trying to implement it, here.](LDA.md) Suffice it to say that we haven't got it to work satisfactorily.

## [*Clustering*](Glossary.md#cluster)

The work we have done on [*Search*](Search.md) relies entirely on the ability to [*embed*](Glossary.md#embedding) our [*documents*](Glossary.md#document) in a vector space. If we can do this, we can use our distance metric (or similarity measure) and do some [*clustering*](Glossary.md#cluster) techniques to group together [*documents*](Glossary.md#document) that are 'close' together in the vector space, and therefore hopefully about similar subjects.

There are many different methods for [*clustering*](Glossary.md#cluster), and I'm not going to go through them here. Suffice it to say that you should try several and compare them for speed of computation and how sensible the results appear to be.

Further complicating the issue is that most techniques require you to set some parameter(s), whether that be explicitly number of [*clusters*](Glossary.md#cluster), or some related measure such as density of points for something to count as a [*cluster*](Glossary.md#cluster) or whatever. This brings up a lot of questions: how do we know that a [*clustering*](Glossary.md#cluster) is the "right" one, or even a "good" one?

For most [*clustering*](Glossary.md#cluster) methodologies there are statistical measures to determine the validity of your parameters choices. For example, for k-means you can look at the [silhouette](https://en.wikipedia.org/wiki/Silhouette_(clustering)) of a [*clustering*](Glossary.md#cluster) as a measure of quality. However, we have found that these measures are lacking: they give a technical idea for the number of [*clusters*](Glossary.md#cluster), but can often result in lots of tight [*clusters*](Glossary.md#cluster) (often including singleton [*clusters*](Glossary.md#cluster)) when frequently the user wants wider, looser collections (and in particular probably never wants a singleton [*cluster*](Glossary.md#cluster)). There is no substitute for you (or the user) looking at the [*clusters*](Glossary.md#cluster) and deciding whether or not they are useful.



## Potential issues

Using an unsupervised machine learning technique for obtaining topics means that there is inevitably an element of black box to proceedings. This air of mystery can have the unwanted side effect that for some topics it can be
* hard to see why the machine has grouped them together, or
* easy to see that the machine has grouped them together because of something we think of as trivial.

The first point is arguably the harder to deal with - if you're not sure why some [*documents*](Glossary.md#document) have been grouped, it's hard to know how to make changes to your [feature selection](FeatureSelection.md) or [*embedding*](Glossary.md#embedding) in order to ungroup them. It can also make it hard to convince the users that the topical [*clusters*](Glossary.md#cluster) you have produced have any semantic meaning. In the worst case, you can see a definition of a topic (in terms of a list of words or of [*documents*](Glossary.md#document)) but you can't articulate what it is about. If this happens too much, your topical discovery is essentially useless to the user. I have found this to be a constant problem when trying [LDA](LDA.md).

The second point can sometimes be fixed by changing [feature selection](FeatureSelection.md) or [*embedding*](Glossary.md#embedding) schemes. For example, with Parliamentary Questions, there was a [*cluster*](Glossary.md#cluster) forming around questions containing the relatively rare word "*steps*", because there are some questions asking the Secretary of State "*what steps* [he/she] *will take*" to solve some issue or other. We want to focus on the issue, rather than this piece of parliamentary fluff language. Finding this [*cluster*](Glossary.md#cluster) allowed us to add the word "*steps*" to our [*stopword*](Glossary.md#stopwords) list which led to those questions being correctly categorised with others about the same topics.

In all cases, time spent looking at your topics/[*clusters*](Glossary.md#cluster) is usually well spent, as it gives you a feel for what your complex bit of algorithmic machinery is actually doing.