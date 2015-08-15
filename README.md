##HOW THE SCRIPT RUN_ANALYSIS.R WORKS

The scripts first load all the tables that we need in order to merge the Samsung test and the train dataset:
  -activity labels
  -features names
  -for the test and training data sets:
    *subject list (for each row of the "X" set)
    *the "X" set which contains all the measurments
    *the "y" set which contains the activity id of each row of the "X" set

Then, it adds the features name to the "X" sets (of both training and test sets) .

Looking at the name of the features, I realized that all the ones which are a mean or standard deviation, are ended with respectively "-mean()" and "-std()". Using the function "grep" that ouputs the position in a character vector of an element containing a specific arrangement or characters, I extract the features names containing "-mean()" and "-std()" (fixed = TRUE allows me to exclude the ones with "-meanFreq()" as grep looks at appearance of the characters in the substring one after the other and would otherwise select that one).

Those columns id are merged together, sorted, and selected from the "X" sets with column names : only the measures for the mean and standard deviations are taken.

Then the "y" sets are merged with the activity labels in order to add the actual name of th acticity instead of its id.

After adding the name of the unique column of the subject lists of both training and test sets (as subject_id), I use "cbind" to add this column to the "X" tables at the beginning, and the "activity" name column from the "y" sets as second position.

Then I use "rbind" to merge the two sets into the "base"" dataset.

The column "subject_id" was automatically set as numeric, but I need it as factor, so I use as.factor to do that. The "levels" function get me all the distinct values of the subjects and ativities (this is handy because some of the subjects do not have data for some of the activities, but I would need NA values for those , so I need to go through all the activities, even those with no data).

To get the final table, I loop across the subjects, and then across the different activities, then take the mean of all 66 features, removing the NA, and use "rbind" to attach the results into an empty dataframe that I created before from "base".

Because the column names of "base"" are not anymore relevant for the column names of "final", as the latter are the mean of the former, I need to change their names, and do that with a loop that goes from the 3rd column (subject_id and activity stay the same), and use the "paste" function to add "mean()" to the original "base" column names.

Finally, I use the function "write.table" to create the text file for submission for this assignment.

This 

