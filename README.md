# Urgencias

This Shiny app shows the visits to emergency rooms across Chile. The data are shown by cause of visit and the user can choose to see three variables: Tipo de establecimiento (whether hospital, or different types of primary care centers), age range, and region. 

## Files

- **helpers.R** carries out the initial analysis of the data.
- **App.R** generates the user interface: it creates a table widget and a graph (a barchart in this case).

The data consist of .parquet files, one per month. At this point I have only downloaded the data from year 2024, just to find out how it worked.

## To-do list

- Clean the data (change caps lock, remove trailing spaces, etc.) from the .parquet files
- Aggregate age range in the .parquet files, not during the query
- Integrate dplyr with duckdb more seamlessly
- Add files from other years
