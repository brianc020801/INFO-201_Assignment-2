# A2: U.S. COVID Trends

## Overview
In many ways, we have come to understand the gravity and trends in the COVID-19 pandemic through quantitative means. Regardless of media source, people are consuming more epidemiological information than ever, primarily through reported figures, charts, and maps. 

This assignment is your opportunity to work directly with the same data used by the New York Times. While the analysis is guided through a series of questions, it is your opportunity to use programming skills to ask more detailed questions about the pandemic.

You'll load the data directly from the [New York Times GitHub page](https://github.com/nytimes/covid-19-data/), and you should make sure to read through their documentation to understand the meaning of the datasets. 

Note, this is a long assignment, meant to be completed over the two weeks when we'll be learning data wrangling skills. I strongly suggest that you **start early**, and approach it with patience. We're asking real questions of real data, and there is inherent trickiness involved. 

## Analysis
You should start this assignment by opening up your `analysis.R` script. The script will guide you through an initial analysis of the data. Throughout the script, there are prompts labeled **Reflection**. Please write 1 - 2 sentences for each of these reflections below:

- What does each row in the data represent (hint: read the [documentation](https://github.com/nytimes/covid-19-data/)!)?  
  + Each row represents the cumulative number of Covid-19 cases and deaths based on NY Times best reporting up to an update.
- What did you learn about the dataset when you calculated the state with the lowest cases (and what does that tell you about testing your assumptions in a dataset)?  
  + There wasn't only just states but US territories as well, this tells me that we need to be sure of what data we have, because when people mention state, we usually only think about the major states and not the territories too.
- Is the location with the highest number of cases the location with the most deaths? If not, why do you believe that may be the case?  
  + No, it wasn't. I believe this was the case because New York is a lot smaller city than Los Angeles, but with way more people, which results in the lack of medical aid that could be provided to such a huge amount of people.
- What do the plots of cases and deaths tell us about the  pandemic happening in "waves"? How (and why, do you think) these plots look so different?
- Why are there so many observations (counties) in the variable `lowest_in_each_state` (i.e., wouldn't you expect the number to be ~50)?  
  + Because there was the counties for US territories and not just the 50 states.
- What surprised you the most throughout your analysis?  
  + I think is that some of the data collected actually showed decrease in cases, which could be an error on the NY Times, because if taking cumulative changes then the total shouldn't decrease.
