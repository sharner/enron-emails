# Analysis of Enron Emails

This is an analysis of Enron Emails (in progress). The ulimate goal is to distinguish among different email authors using a combination of topic analysis, social network analysis, sentiment anaysis, and classification.

# Importing the Data

Download the Enron [Email Data Set](https://www.cs.cmu.edu/~enron/).  Then follow the steps in [input_analysis.Rmd](https://github.com/sharner/enron-emails/blob/master/notebooks/input_analysis.Rmd).

# Topic Analysis

The goal of topic analysis is to group emails into N topics using Latent Dirichlet  Association (LDA), as shown in [sender_topic_analysis.Rmd](https://github.com/sharner/enron-emails/blob/master/notebooks/sender_topic_analysis.Rmd).

# Social Network Analysis

The goal of social network analysis is study who is sending messages to whom, shown in [social_network_analysis.Rmd](https://github.com/sharner/enron-emails/blob/master/notebooks/social_network_analysis.Rmd).

# Classification of Author

Classifcation predicts if an email was written by the author in question.  It compares emails by the author to a sample of emails from other authors from predictors, such as email length, average word length, the ratio of character counts, etc., shown in [single_user_model_analysis.Rmd](https://github.com/sharner/enron-emails/blob/master/notebooks/single_user_model_analysis.Rmd).

# Future Work

* Complete social network analysis
* Incorporate SNA and LDA into the classification model
* Develop a multinoulli model to choose an author
* Perform the analysis in time slices to accomodate changes in user behavior
