# Neural Network models

## TL; DR

* What we here call Neural Network models refers to a whole set of methods for [*embedding*](Glossary.md) words (and also sometimes [*documents*](Glossary.md)) into a vector space, by the use of a neural network. Examples include Word2Vec, Doc2Vec, and FastText.
* There are a wide variety of such methods; for example Word2Vec is actually not one but two separate methods (CBOW and skip-gram).
* The word [*embeddings*](Glossary.md) can either be trained on the corpus of interest, or can be downloaded as a pre-trained set of vectors trained on a large corpus e.g. Wikipedia. Which is more appropriate will depend on your aims.
* The [*embeddings*](Glossary.md) can be of any number of dimensions; Word2Vec guidance is vague on this and suggests between 100 and 1000. Typically more dimensions = greater quality encoding, but there will be some limit beyond which you'll get diminishing returns. We typically use 200 or 300.
* The output vectors encode both semantic and syntactic meaning, and we can do some algebra with them. For example with the Word2Vec pretrained vectors we get **France** + **Berlin** - **Germany** = **Paris**, and also **faster** + **warm** - **fast** = **warmer** (where **term** is the vector representing "*term*", additions and subtractions are as usual with vectors, and the equals operator in this case means "closest pre-defined vector", e.g. **Paris** is the closest predefined vector to the vector we get when doing the sum **France** + **Berlin** - **Germany**).
* Either directly, or by combining word vectors in some way, we can get [*embeddings*](Glossary.md) for our [*documents*](Glossary.md), which means we can do [*Search*](Search.md) or find [*Topics*](Topics.md) in the usual manner.