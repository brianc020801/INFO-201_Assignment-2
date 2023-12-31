# Overview ----------------------------------------------------------------

# Assignment 2: U.S. COVID Trends
# For each question/prompt, write the necessary code to calculate the answer.
# For grading, it's important that you store your answers in the variable names
# listed with each question in `backtics`. Please make sure to store the
# appropriate variable type (e.g., a string, a vector, a dataframe, etc.)
# For each prompt marked `Reflection`, please write a response
# in your `README.md` file.



# Loading data ------------------------------------------------------------

# You'll load data at the national, state, and county level. As you move through
# the assignment, you'll need to consider the appropriate data to answer
# each question (though feel free to ask if it's unclear!)

# Load the tidyverse package
library(tidyverse)

# Load the *national level* data into a variable. `national`
# (hint: you'll need to get the "raw" URL from the NYT GitHub page)

#national <- read.csv(url("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us.csv"))

# Load the *state level* data into a variable. `states`

#states <- read.csv(url("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv"))

# Load the *county level* data into a variable. `counties`
# (this is a large dataset, which may take ~30 seconds to load)

#counties <- read.csv(url("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv"))

# How many observations (rows) are in each dataset?
# Create `obs_national`, `obs_states`, `obs_counties`

#655
obs_national <- nrow(national)

#33774
obs_states <- nrow(states)

#1888095
obs_counties <- nrow(counties)

# Reflection: What does each row represent in each dataset?


# How many features (columns) are there in each dataset?
# Create `num_features_national`, `num_features_states`, `num_features_counties`

#3
num_features_national <- ncol(national)

#5
num_features_states <- ncol(states)

#6
num_features_counties <- ncol(counties)

# Exploratory analysis ----------------------------------------------------

# For this section, you should explore the dataset by answering the following
# questions. HINT: Remeber that in class, we talked about how you can answer 
# most data analytics questions by selecting specific columns and rows. 
# For this assignemnt, you are welcome to use either base R dataframe indexing or
# use functions from the DPLYR package (e.g., using `pull()`). Regardless, you 
# must return the specific column being asked about. For example, if you are 
# asked the *county* with the highest number of deaths, your answer should
# be a single value (the name of the county: *not* an entire row of data).
# (again, make sure to read the documentation to understand the meaning of
# each row -- it isn't immediately apparent!)

# How many total cases have there been in the U.S. by the most recent date
# in the dataset? `total_us_cases`

#46395307
total_us_cases <- select(filter(national, cases == max(cases)), cases)[[1]]

# How many total deaths have there been in the U.S. by the most recent date
# in the dataset? `total_us_deaths`

#753517
total_us_deaths <- select(filter(national, deaths == max(deaths)), deaths)[[1]]

# Which state has had the highest number of cases?
# `state_highest_cases`

#California
state_highest_cases <- select(filter(states, cases == max(cases)), state)[[1]]

# What is the highest number of cases in a state?
# `num_highest_state`

#4959010
num_highest_state <- select(filter(states, cases == max(cases)), cases)[[1]]

# Which state has the highest ratio of deaths to cases (deaths/cases), as of the
# most recent date? `state_highest_ratio`
# (hint: you may need to create a new column in order to do this!)

#New Jersey
state_highest_ratio <- select(filter(summarise(group_by(states, state), ratio = max(deaths)/max(cases)), ratio == max(ratio)), state)[[1]]

# Which state has had the lowest number of cases *as of the most recent date*?
# (hint, this is a little trickier to calculate than the maximum because
# of the meaning of the row). `state_lowest_cases`

#American Samoa
state_lowest_cases <- select(filter(summarise(group_by(states, state), cases = max(cases)), cases == min(cases)), state)[[1]]

# Reflection: What did you learn about the dataset when you calculated
# the state with the lowest cases (and what does that tell you about
# testing your assumptions in a dataset)?

# Which county has had the highest number of cases?
# `county_highest_cases`

#Los Angeles
county_highest_cases <- select(filter(counties, cases == max(cases)), county)[[1]]

# What is the highest number of cases that have happened in a single county?
# `num_highest_cases_county`

#1500615
num_highest_cases_county <- select(filter(counties, cases == max(cases)), cases)[[1]]

# Because there are multiple counties with the same name across states, it
# will be helpful to have a column that stores the county and state together
# (in the form "COUNTY, STATE").
# Add a new column to your `counties` data frame called `location`
# that stores the county and state (separated by a comma and space).
# You can do this by mutating a new column, or using the `unite()` function
# (just make sure to keep the original columns as well)

counties <- mutate(counties, location = sprintf("%s, %s", county, state))

# What is the name of the location (county, state) with the highest number
# of deaths? `location_most_deaths`

#New York City, New York
location_most_deaths <- select(filter(counties, deaths == max(na.omit(deaths))), location)[[1]]

# Reflection: Is the location with the highest number of cases the location with
# the most deaths? If not, why do you believe that may be the case?


# At this point, you (hopefully) have realized that the `cases` column *is not*
# the number of _new_ cases in a day (if not, you may need to revisit your work)
# Add (mutate) a new column on your `national` data frame called `new_cases`
# that has the nubmer of *new* cases each day (hint: look for the `lag`
# function).

national <- mutate(national, new_cases = cases - lag(cases, 1))

# Similarly, the `deaths` columns *is not* the number of new deaths per day.
# Add (mutate) a new column on your `national` data frame called `new_deaths`
# that has the nubmer of *new* deaths each day

national <- mutate(national, new_deaths = deaths - lag(deaths, 1))


# What was the date when the most new cases occured?
# `date_most_cases`

#2021-09-07
date_most_cases <- select(filter(national, new_cases == max(na.omit(new_cases))), date)[[1]]

# What was the date when the most new deaths occured?
# `date_most_deaths`

#2021-02-12
date_most_deaths <- select(filter(national, new_deaths == max(na.omit(new_deaths))), date)[[1]]

# How many people died on the date when the most deaths occured? `most_deaths`

#5463
most_deaths <- select(filter(national, new_deaths == max(na.omit(new_deaths))), new_deaths)[[1]]

# Grouped analysis --------------------------------------------------------

# An incredible power of R is to perform the same computation *simultaneously*
# across groups of rows. The following questions rely on that capability.

# What is the county with the *current* (e.g., on the most recent date)
# highest number of cases in each state? Your answer, stored in
# `highest_in_each_state`, should be a *vector* of
# `location` names (the column with COUNTY, STATE).
# Hint: be careful about the order of filtering your data!

highest_in_each_state <- select(summarize(group_by(arrange(counties, desc(cases)), state), location = first(location)), location)[[1]]

# What is the county with the *current* (e.g., on the most recent date)
# lowest number of deaths in each state? Your answer, stored in
# `lowest_in_each_state`, should be a *vector* of
# `location` names (the column with COUNTY, STATE).

lowest_in_each_state <- select(summarize(group_by(arrange(counties, deaths), state), location = first(location)), location)[[1]]

# Reflection: Why are there so many observations (counties) in the variable
# `lowest_in_each_state` (i.e., wouldn't you expect the number to be ~50)?

# The following is a check on our understanding of the data.
# Presumably, if we add up all of the cases on each day in the
# `states` or `counties` dataset, they should add up to the number at the
# `national` level. So, let's check.

# First, let's create `state_by_day` by adding up the cases on each day in the
# `states` dataframe. For clarity, let's call the column with the total cases
# `state_total`
# This will be a dataframe with the columns `date` and `state_total`.

state_by_day <- summarize(group_by(states, date), state_total = sum(cases))

# Next, let's create `county_by_day` by adding up the cases on each day in the
# `counties` dataframe. For clarity, let's call the column with the total cases
# `county_total`
# This will also be a dataframe, with the columns `date` and `county_total`.

county_by_day <- summarize(group_by(counties, date), county_total = sum(cases))

# Now, there are a few ways to check if they are always equal. To start,
# let's *join* those two dataframes into one called `totals_by_day`

totals_by_day = full_join(state_by_day, county_by_day)

# Next, let's create a variable `all_totals` by joining `totals_by_day`
# to the `national` dataframe

all_totals <- full_join(national, totals_by_day)

# How many rows are there where the state total *doesn't equal* the natinal
# cases reported? `num_state_diff`

#0
num_state_diff <- nrow(filter(all_totals, cases != state_total))

# How many rows are there where the county total *doesn't equal* the natinal
# cases reported? `num_county_diff`

#29
num_county_diff <- nrow(filter(all_totals, cases != county_total))

# Oh no! An inconsistency -- let's dig further into this. Let's see if we can
# find out *where* this inconsistency lies. Let's take the county level data,
# and add up all of the cases to the state level on each day (e.g.,
# aggregating to the state level). Store this dataframe with three columns
# (state, date, county_totals) in the variable `sum_county_to_state`.
# (To avoid DPLYR automatically grouping your results,
# specify `.groups = "drop"` in your `summarize()` statement. This is a bit of
# an odd behavior....)

sum_county_to_state <- counties %>% group_by(state, date) %>% dplyr::summarize(.groups = "drop", county_totals = sum(cases))
# Then, let's join together the `sum_county_to_state` dataframe with the
# `states` dataframe into the variable `joined_states`.

joined_states = full_join(states, sum_county_to_state)

# To find out where (and when) there is a discrepancy in the number of cases,
# create the variable `has_discrepancy`, which has *only* the observations
# where the sum of the county cases in each state and the state values are
# different. This will be a *dataframe*.

has_discrepancy <- filter(joined_states, county_totals != cases)

# Next, lets find the *state* where there is the *highest absolute difference*
# between the sum of the county cases and the reported state cases.
# `state_highest_difference`.
# (hint: you may want to create a new column in `has_discrepancy` to do this.)

#Missouri
has_discrepancy <- mutate(has_discrepancy, abs_difference = abs(county_totals - cases))
state_highest_difference <- select(filter(has_discrepancy, abs_difference == max(abs_difference)), state)[[1]]

# Independent exploration -------------------------------------------------

# Ask your own 3 questions: in the section below, pose 3 questions,
# then use the appropriate code to answer them.


#Which day in NY has the most deaths

#2020-04-07
ny_deaths <- filter(states, state == "New York")
ny_deaths <- mutate(ny_deaths, new_deaths = deaths - lag(deaths, 1))
ny_day_with_most_deaths <- select(filter(ny_deaths, new_deaths == max(na.omit(new_deaths))), date)[[1]]


#Which day in California has the most cases

#2020-12-26
california_cases <- filter(states, state == "California")
california_cases <- mutate(california_cases, new_cases = cases - lag(cases, 1))
cali_day_with_most_cases <- select(filter(california_cases, new_cases == max(na.omit(new_cases))), date)[[1]]

#State with lowest absolute difference between sum county cases and reported state cases

#Iowa
state_lowest_difference <- select(filter(has_discrepancy, abs_difference == min(abs_difference)), state)[[1]]

# Reflection: What surprised you the most throughout your analysis?
