# Feature selection

## TL; DR

* We want to [*embed*](Glossary.md) our [*documents*](Glossary.md) into a vector space in a way that takes account of what we think is important about them.
* Feature selection is the process of selecting what we think is worthwhile in our [*documents*](Glossary.md), and what can be ignored.
* This will likely include removing [*stopwords*](Glossary.md), and modifying words by making them lower case, choosing what to do with typos or grammar features, and choosing whether to do [*stemming*](Glossary.md).
* Decisions about how to do these things are usually made by trial and error.
* The order you follow when doing these processes is not always fixed, and it can take some thought to work out the most efficient way.
* When turning [*documents*](Glossary.md) into vectors, there isn't a hard and fast distinction between which processes are feature selection and which are part of the [*embedding*](Glossary.md) schema; rather it's one long process.

## Motivation

We want to decide how to [*embed*](Glossary.md) our [*documents*](Glossary.md) into a vector space in a way that takes account of what we think is important about them. This means that we need to formally define which elements of our [*documents*](Glossary.md) are worth taking notice of, and which can be safely ignored (this is a standard requirement in any machine learning project).

In natural language processing typically our only possibility is choosing which words in a [*document*](Glossary.md) we should consider, and whether we should do any transformation of these words.

## Choosing words to keep and drop

Typically we want to choose the words that give us the most meaning for our [*document*](Glossary.md). In practical terms we have always actually focussed on which words to remove.

The advantage of removing words from our analysis is twofold. First, by focussing less on words that we aren't interested in, we hope that the resulting [*embedding*](Glossary.md) of the [*documents*](Glossary.md) encodes their relevant content rather than irrelevant aspects. Second, by reducing the size of the [*vocabulary*](Glossary.md) we can help reduce the memory required to store our calculations and hopefully make things runs faster.

There are different methods to follow when deciding which words to remove from analysis. They are not mutually exclusive, and in fact there will often be some overlap between them. Care is needed when thinking about which of these methods to use, and which order to apply them in. Where we have used multiple methods we have often followed a 'belt and braces' approach and not worried about the redundancy in parts of our procedure. It would be better to be clear from the start about what we want to remove, because redundant processes at best waste time, and at worst create unforeseen consequences.

### Stopwords

One method of removing words we don't want our model to consider is to create a list of [*stopwords*](Glossary.md) that are always to be ignored.

So how do we go about deciding what to add to our [*stopword*](Glossary.md) list? Many of the obviously removable words are things like *and*, *of*, or *the*, which have linguistic or grammatical content but do not obviously have a lot to do with what a [*document*](Glossary.mnd) is *about*. Fortunately the removal of these words is so standard in natural language processing practice that there are various lists of such words already available (e.g. the [SMART list](http://www.lextek.com/manuals/onix/stopwords2.html)), with implementations in various coding languages.

Once we have removed the obvious [*stopwords*](Glossary.md) we may be done. Alternatively, sometimes we may want to also remove other words that have little meaning or importance in our specific context.

When we were doing natural language processing on Parliamentary Questions for the Ministry of Justice, we found that more or less all of the PQs (our [*documents*](Glossary.md)) contained some variant of the phrases "*ask the Secretary of State for Justice*" or "*ask the Ministry of Justice*". Keeping in "*Secretary of State for*" or "*Ministry of*" thus led to an [*embedding*](Glossary.md) in which our [*documents*](Glossary.md) were partitioned according to which of these set phrases the question used at the start, even though this added nothing to the information content of the [*documents*](Glossary.md). So we added *secretary*, *state*, and *ministry* to our bespoke list of [*stopwords*](Glossary.md) (*of* and *for* having already been removed by a standard [*stopword*](Glossary.md) list).

These bespoke [*stopwords*](Glossary.md) are typically added in an iterative, trial-and-error process. In the case of parliamentary questions, we still add to our bespoke stopword list now and again - [the current list is here if you're interested](https://github.com/moj-analytical-services/pq-tool/blob/master/.Rprofile).

### Words of low or high frequency

Another way of choosing words to remove is to take out those that appear in very few or almost all [*documents*](Glossary.md).

Words that appear in very few [*documents*](Glossary.md) might be unique typos, or have such little connection to the general topics found in the [*corpus*](Glossary.md), that they can be safely ignored. This is typically done by defining some number of [*documents*](Glossary.md) as a minimum threshold: any words that appear in fewer [*documents*](Glossary.md) than the threshold are discarded.

Conversely, words that appear in almost all documents are probably standard language that add little of value in this context. By definition, if a word appears in all documents it cannot help us distinguish between them and so is of no value as a feature. Again, we usually define a threshold value and say that if any words appear in more than this number of [*documents*](Glossary.md) they can be discarded.

I am ambivalent about this practice, but currently I tend towards thinking that it's quite unsatisfying as a way of removing words from analysis. The problem is that in all of our projects so far we have also used [*IDF weighting*](Glossary.md) in assigning a weight to words. This means words that appear in almost all [*documents*](Glossary.md) are already weighted with a very low score. It also means that philosophically we are assuming that the fewer [*documents*](Glossary.md) that a word appears in, the more information that it includes: it seems somewhat contradictory to state that this increase in information has an arbitary limit below which the words then include no information. But maybe I've missed something.

### Very short words

Some feature selection schemes automatically drop all words that are shorter than some threshold number of letters. To be honest I am unsure of the rationale behind this: I can see that, for example, 2-letter words often add little of value, but *of* and *as* and *is* will already be cut out as [*stopwords*](Glossary.md). Remaining 2-letter words might include important concepts like *EU* or *UK* and in my opinion care should be taken in automatically dropping them. It's worth checking out default settings because in R's `tm` package, for example, this short word removal is done as a silent default unless you specify otherwise.

## Altering the text

### Capital letters

Capital letters at the start of words often signify nothing other than the fact that the word was used to start the sentence, not in itself indicative of very much. Unless we explicitly do something, our [*vocabulary*](Glossary.md) will have two versions of some words, both with and without capital letters at the start: e.g. for this document it would have both "*Capital*" and "*capital*" in it.

The easiest way around this problem is to make all of the text in our [*corpus*](Glossary.md) lower case at some stage in our pipeline. Usually this is done before removing [*stopwords*](Glossary.md), because then the list of [*stopwords*](Glossary.md) can be entirely lower case and we can be sure that we are removing all instances of those words regardless of whether they happen to appear at the start of a sentence.

However, there are occasions when a capitalised first letter does impart meaning. In the case of our work on PQs, we wanted to remove the word *Justice* (capitalised first letter) because it features whenever people ask questions of the "*Secretary of State for Justice*" or the "*Ministry of Justice*", and doesn't impart much meaning (it's unimportant whether or not the person asking the question referenced the department or Secretary of State or not). However, we wanted to leave in the word *justice* (uncapitalised first letter) because it features when people are talking about "*youth justice*" or "*family justice*", which could be an important signifier of the topical content of the question. Our solution was to have two rounds of [*stopword*](Glossary.md) removal, one before and one after making the text lower case. We could then remove *Justice* before making everything lower case and removing the standard the other bespoke stopwords.

### Typos and grammatical quirks

Sometimes typos 



