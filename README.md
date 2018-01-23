# Analysis of Enron Emails

This is an analysis of Enron Emails.  It is a work in progress with the ulimate goal distinguishing among different email authors using a combination of topic analysis, social network analysis, sentiment anaysis, and classification based on extracted features.

# Importing the Data

Download the Enron [Email Data Set](https://www.cs.cmu.edu/~enron/).  Then run follow the steps in [input_analysis.Rmd]|(https://github.com/sharner/enron-emails/blob/master/notebooks/input_analysis.Rmd).

# Topic Analysis

The goal of topic analysis is to group emails into N topics using Latent Dirichlet  Association (LDA), as shown in [sender_topic_analysis.Rmd](https://github.com/sharner/enron-emails/blob/master/notebooks/sender_topic_analysis.Rmd).

# Social Network Analysis

The goal of social network analysis is study who is sending messages to whom, shown in [social_network_analysis.Rmd](https://github.com/sharner/enron-emails/blob/master/notebooks/social_network_analysis.Rmd).

# Classification of Author

Classifcation attempts to confirm if an email was written by the author in question.  It compares emails author by the author to a sample of emails from other authors and extracts a set of features, such as email length, average word length, the ratio of character counts, to serve as predictors, shown in [single_user_model_analysis.Rmd](https://github.com/sharner/enron-emails/blob/master/notebooks/single_user_model_analysis.Rmd).

# Future Work

* Complete social network analysis
* Incorporate Social Network Analysis and Topic Analysis into the classification model
* Attempt a multinoulli classification to choose an author
* Perform the analysis in time slices to accomodate changes in user behavior
