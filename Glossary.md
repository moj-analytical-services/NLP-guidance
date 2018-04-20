# Glossary

## Corpus
The set of text *document*s that you are analysing.
### Examples
* The set of written parliamentary questions that the Ministry of Justice has answered since a give date.

* The set of sentences from all prison inspection reports since a given date.

* A set of emails sent to a particular person.

## Document
A text object, the collection of which make up your *corpus*. If you are doing work on *Search* or *Topics*, the *document*s will be the objects which you will be finding similarities between in order to group them topically. The length and definition of a *document* will depend on the question you are answering.
### Examples
* A written parliamentary question
* A text message sent to a mobile phone
* A novel
* A sentence from a prison report

## Embedding
The process whereby *documents* or words are coded up as a vector in some (typically very high-dimensional) vector space.
### Examples
* Counting the number of times a *document* contains the words biscuit or biscuits and assigning this number to the  *document*
* Latent semantic analysis
* Neural network models like Word2Vec, Doc2Vec, FastText, etc.

## Inverse Document Frequency (IDF) weighting
Assigning a weight to words in the *vocabulary* to represent how much we should take note of their appearance or non-appearance in a *document*, based on what proportion of *documents* in the *corpus* those words appear in. There are [various IDF schemes](https://en.wikipedia.org/wiki/Tf%E2%80%93idf#Inverse_document_frequency_2); we have always used the standard
$$\log \frac{N}{n_t}$$
weighting for a word $t$, where $N$ is the total number of *documents* in the *corpus*, and $n_t$ is the number of *documents* that contain $t$.

## Stemming
The practice of reducing words to their roots. This reduces the number of words in a vocabulary, and focusses *embedding* on the concept that the word is trying to encode, rather than the grammatical context of the word. We have generally done it using the [Porter algorithm](https://tartarus.org/martin/PorterStemmer/), which has implementations in a number of programming languages including R.
### Examples
* Reducing plural nouns to the singular - *biscuits* to *biscuit*
* Reducing verbs to their roots - *accused*, *accuse*, *accuses*, *accusing* all transformed to the root *accus*
* You can see a list of words [here](https://tartarus.org/martin/PorterStemmer/voc.txt) and their stemmed equivalents [here](https://tartarus.org/martin/PorterStemmer/output.txt)

## Stopwords
Words routinely removed from *document*s at an early stage of the analysis.
### Examples
* These can be taken from a standard list of English stopwords (e.g. words like *and*, *of*, or *the*)
* They can also be from a bespoke project-specific list (e.g. the phrase *Secretary of State* in the case of Parliamentary Questions)

## Vocabulary
The set of all words used in the *corpus*, after *stopwords* have been removed and *stemming* has been done (where appropriate).
### Examples
* The *corpus* of sentences taken from Dr Seuss' children's book "*Green Eggs and Ham*" has the following *vocabulary*:
a, am, and, anywhere, are, be, boat, box, car, could, dark, do, eat, eggs, fox, goat, good, green, ham, here, house, I, if, in, let, like, may, me, mouse, not, on, or, rain, Sam, say, see, so, thank, that, the, them, there, they, train, tree, try, will, with, would, you ([source](https://wordobject.wordpress.com/2011/05/18/lists-green-eggs-and-ham/)).
* The *vocabulary* of that  corpus* after removing *stopwords* featured in the [SMART list](http://www.lextek.com/manuals/onix/stopwords2.html):
boat, box, car, dark, eat, eggs, fox, goat, good, green, ham, house, I, mouse, rain, Sam, train, tree
* The *vocabulary* of that  corpus* after removing *stopwords* from the [SMART list](http://www.lextek.com/manuals/onix/stopwords2.html) and *stemming*:
boat, box, car, dark, eat, egg, fox, goat, good, green, ham, hous, I, mous, rain, Sam, train, tree
