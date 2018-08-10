# Code

## TL; DR

* You can do [LSA](../LSA.md) or [LDA](../LDA.md) in R using the `NLP-guidance.Rproj` R project file
* You can try some [pre-trained Neural Network generated vectors](../NNmodels.md) in Python via the `Pretrained_vectors.ipynb` file

## Motivation

To let you try out some of these ideas in practice, because I think that's a good way to learn.

## Data

The data we use for practicing these techniques is the text in this guide, because I like pretentious self-reference in writing. Also because hopefully you're familiar enough with the text to get a feel for the techniques in practice.

## Data preparation

There is a `data_preparation.R` script, which gets the text from the guide and stores it in a usable format for the code. 

### For LSA in R

The `data_preparation.R` script is `source`d at the beginning of the `LSA.R` script, which uses the `clean_word_counts` object it creates.

### For LDA in R

The `data_preparation.R` script is `source`d at the beginning of the `LDA.R` script, which uses the `full_text` and `full_word_counts` objects it creates.

### For NN word vectors in Python

You need the `sentences.csv` file which `data_preparation.R` generates. This is included in this repo, but you may want to regenerate it.

You also need to go to

https://github.com/plasticityai/magnitude#pre-converted-magnitude-formats-of-popular-embeddings-models

download some vectors of your choice (these files are large so it might take a while) and store them somewhere you can access. The code works by you writing in the appropriate filepath to access the vectors.

## How do I run the code!?

Hopefully each piece of code is annotated so that you can run it. If not, or if something is insufficiently clear, please let me know.


___

[Back to contents](../README.md)
