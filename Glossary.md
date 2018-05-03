# Glossary

### Bag of words <a name="bow"></a>
An approach to *embedding* in which the order of words in a *document* is not considered, just the presence or absence (or sometimes quantity) of terms.
##### Examples
* To a bag of words model, "leave your stuff with the civil servants”, “the civil servants leave with your stuff", and “stuff the civil servants, with your leave” are all seen as the same set {civil, leave, servants, stuff, the, with, your}, and thus all have the same meaning.
* An Artifical Intelligence using a bag of words model would not get any enjoyment from the Wendy Cope poem ["*The Uncertainty of the Poet*"](http://frombooksofpoems.blogspot.co.uk/2007/03/uncertainty-of-poet-by-wendy-cope.html).

### Clustering <a name="cluster"></a>
A catch-all term for a group of algorithms that aim to collect *documents* into clusters. The idea is that the documents within each cluster have something in common, and in particular that they have more in common with each other than with documents from outside the cluster.

Clustering algorithms typically require some measure of distance (or, to some extent equivalently, similarity) between *documents* in a vector space. There are a lot of different algorithms that can be used, all with pros and cons depending on the situation.


### Corpus <a name="corpus"></a>
The set of text *document*s that you are analysing.
##### Examples
* The set of written parliamentary questions that the Ministry of Justice has answered since a give date.

* The set of sentences from all prison inspection reports since a given date.

* A set of emails sent to a particular person.

### Cosine similarity <a name="cossim"></a>
A way of measuring similarity between *documents* after they have been *embedded* as vectors. The gist is that the similarity between any two documents *a* and *b* is judged by the angle _&theta;_. between their vectors **a** and **b**. To be specific, we use the cosine of this angle:

<a href="https://www.codecogs.com/eqnedit.php?latex=\text{Similarity&space;of&space;}\textbf{a}\text{&space;and&space;}\textbf{b}&space;=&space;\cos&space;\theta" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\text{Similarity&space;of&space;}\textbf{a}\text{&space;and&space;}\textbf{b}&space;=&space;\cos&space;\theta" title="\text{Similarity of }\textbf{a}\text{ and }\textbf{b} = \cos \theta" /></a>

The rationale for this is that the vector space into which we *embed* our *documents* is defined such that the dimensions in it approximately relate to the concepts within the *documents*. The vector for a *document* points in the directions of the concepts that *document* contains. Therefore two *documents* with similar conceptual content will have vectors that point in similar directions: the angle between their vectors will be relatively small, so the cosine of this angle will be larger than that between documents with no conceptual similarity.

Note that cosine similarity is a [similarity measure](https://en.wikipedia.org/wiki/Similarity_measure) rather than a [metric](https://en.wikipedia.org/wiki/Metric_(mathematics)).


### Document <a name="document"></a>
A text object, the collection of which make up your *corpus*. If you are doing work on *Search* or *Topics*, the *document*s will be the objects which you will be finding similarities between in order to group them topically. The length and definition of a *document* will depend on the question you are answering.
##### Examples
* A written parliamentary question.
* A text message sent to a mobile phone.
* A novel.
* A sentence from a prison report.

### Embedding <a name="embedding"></a>
The process whereby *documents* or words are coded up as a vector in some (typically very high-dimensional) vector space.
##### Examples
* Counting the number of times a *document* contains the words biscuit or biscuits and assigning this number to the  *document*.
* Latent semantic analysis.
* Neural network models like Word2Vec, Doc2Vec, FastText, etc.

### Inverse Document Frequency (IDF) weighting <a name="idf"></a>
Assigning a weight to words in the *vocabulary* to represent how much we should take note of their appearance or non-appearance in a *document*, based on what proportion of *documents* in the *corpus* those words appear in. There are [various IDF schemes](https://en.wikipedia.org/wiki/Tf%E2%80%93idf#Inverse_document_frequency_2); we have always used the standard


<a align='center' href="https://www.codecogs.com/eqnedit.php?latex=\log&space;\frac{N}{n_t}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\log&space;\frac{N}{n_t}" title="\log \frac{N}{n_t}" /></a>


weighting for a word *t*, where *N* is the total number of *documents* in the *corpus*, and *n~t~* is the number of *documents* that contain *t*.

### Normalising <a name="norm"></a>
Transforming a vector so that it has unit length, by dividing the initial vector by its (Euclidean) length. If you are using *cosine similarity* to measure similarities between *document* vectors, normalising the vectors is often a good idea because, for vectors **a** and **b**

<a href="https://www.codecogs.com/eqnedit.php?latex=\textbf{a}.\textbf{b}&space;=&space;|\textbf{a}||\textbf{b}|&space;\cos&space;\theta" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\textbf{a}.\textbf{b}&space;=&space;|\textbf{a}||\textbf{b}|&space;\cos&space;\theta" title="\textbf{a}.\textbf{b} = |\textbf{a}||\textbf{b}| \cos \theta" /></a>

where  *\theta* is the angle between **a** and **b**. If we denote the normalised versions of **a** and **b** as **a'** and **b'** respectively, we have <a href="https://www.codecogs.com/eqnedit.php?latex=\inline&space;|\textbf{a}|&space;=&space;|\textbf{b}|&space;=&space;1" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\inline&space;|\textbf{a}|&space;=&space;|\textbf{b}|&space;=&space;1" title="|\textbf{a}| = |\textbf{b}| = 1" /></a>, so

<a href="https://www.codecogs.com/eqnedit.php?latex=\cos&space;\theta&space;=&space;\textbf{a}^{\prime}.\textbf{b}^{\prime}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\cos&space;\theta&space;=&space;\textbf{a}^{\prime}.\textbf{b}^{\prime}" title="\cos \theta = \textbf{a}^{\prime}.\textbf{b}^{\prime}" /></a>

 Dot products are typically much quicker to compute than cosines, and normalisation is quick, so this saves time.

### Stemming <a name="stem"></a>
The practice of reducing words to their roots. This reduces the number of words in a vocabulary, and focusses *embedding* on the concept that the word is trying to encode, rather than the grammatical context of the word. We have generally done it using the [Porter algorithm](https://tartarus.org/martin/PorterStemmer/), which has implementations in a number of programming languages including R.
##### Examples
* Reducing plural nouns to the singular - *biscuits* to *biscuit*.
* Reducing verbs to their roots - *accused*, *accuse*, *accuses*, *accusing* all transformed to the root *accus*.
* You can see a list of words [here](https://tartarus.org/martin/PorterStemmer/voc.txt) and their stemmed equivalents [here](https://tartarus.org/martin/PorterStemmer/output.txt).

### Stopwords <a name="stopwords"></a>
Words routinely removed from *document*s at an early stage of the analysis.
##### Examples
* These can be taken from a standard list of English stopwords (e.g. words like *and*, *of*, or *the*).
* They can also be from a bespoke project-specific list (e.g. the phrase *Secretary of State* in the case of Parliamentary Questions).

### Term-document matrix (TDM) <a name="tdm"></a>
A matrix, the columns of which are the vectors representing our *documents*, and the rows the words in our *vocabulary*. Used in [*Latent Semantic Analysis*](LSA.md). Defines a subspace of our initial vector space, the rank of which is the smaller out of the number of documents and the size of the vocabulary.

Sometimes algorithms require a Document-Term Matrix (DTM) instead of a TDM; this is just the transpose of the TDM.

Beware that the terminology for these objects can be confused; for example, in R the package `lsa` contains the key function `lsa()` which will do the singular value decomposition that you want (see [LSA page for details](LSA.md)). This function claims that its input must be
> ...a document-term matrix ... containing *documents in colums, terms in rows*...

(emphasis mine). However, the `TermDocumentMatrix()` function from the `tm` package, [along with Wikipedia](https://en.wikipedia.org/wiki/Document-term_matrix), agrees with our definition above.

The semantics aren't important, but care needs to be taken because when you do a singular value decomposition as part of LSA, you need to know which of the three matrices created corresponds to terms, and which to *documents*.

### Vocabulary <a name="vocab"></a>
The set of all words used in the *corpus*, after *stopwords* have been removed and *stemming* has been done (where appropriate).
##### Examples
* The *corpus* of lines taken from Dr Seuss' children's book "*Green Eggs and Ham*" has the following *vocabulary* ([source](https://wordobject.wordpress.com/2011/05/18/lists-green-eggs-and-ham/)):
> a, am, and, anywhere, are, be, boat, box, car, could, dark, do, eat, eggs, fox, goat, good, green, ham, here, house, I, if, in, let, like, may, me, mouse, not, on, or, rain, Sam, say, see, so, thank, that, the, them, there, they, train, tree, try, will, with, would, you
* The *vocabulary* of that  *corpus* after removing *stopwords* featured in the [SMART list](http://www.lextek.com/manuals/onix/stopwords2.html) (note that all stopwords in this list are lower case):
> boat, box, car, dark, eat, eggs, fox, goat, good, green, ham, house, I, mouse, rain, Sam, train, tree.
* The *vocabulary* of that  *corpus* after making lower case, removing *stopwords* from the [SMART list](http://www.lextek.com/manuals/onix/stopwords2.html) and *stemming* (note that because we made everything lower case, the word "*I*" is now removed:
> boat, box, car, dark, eat, egg, fox, goat, good, green, ham, hous, mous, rain, sam, train, tree.

### Weighting scheme <a name="weighting"></a>
The scheme by which we go from a vector of counts of each word in the *vocabulary* for a given document to an *embedding*. Typically made up of three elements: term frequency, *inverse document frequency*, and *normalisation*.
##### Example
* Simply count the occurrences of each word in the the vocabulary, and don't worry about *inverse document frequency* or *normalisation*.
* Use a Boolean approach to term frequency, recording only the appearance (score 1) or non-appearance (score 0) of words rather than their frequency; multiply this by the *inverse document frequency* score for the word; then *normalise* the resultant vector. This is the weighting scheme used in the Parliamentary Analysis Tool.