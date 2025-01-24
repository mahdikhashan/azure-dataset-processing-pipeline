# Manipulate IRIS dataset

This script processes data from an Azure Blob Storage container and uploads the results to another container.

## Functionality

1. Connects to Azure Blob Storage using a connection string
2. Downloads a CSV file ('iris.csv') from the 'raw' container
3. Loads the CSV data into a pandas DataFrame
4. Filters the DataFrame to include only 'setosa' species
5. Uploads the filtered data as a new CSV file ('iris_setosa.csv') to the 'out' container

## Requirements

- Azure Storage Blob library
- pandas library

## Usage

Ensure the connection string and container/blob names are correctly set before running the script.

## Note

Handle the connection string securely and do not expose it in public repositories.


---
generated with perplexity.ai with the following prompt:

```text
generate a very short and simple doc for this script to be kept as markdown in the repo: manipulate_csv.py
```
