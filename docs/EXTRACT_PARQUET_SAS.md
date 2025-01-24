# Extract MNIST from parquet format

This script extracts metadata from a Parquet file stored in Azure Blob Storage, processes its contents, and uploads the results back to Azure Blob Storage. Here's a brief overview of its functionality:

1. Connects to Azure Blob Storage using a connection string
2. Downloads a Parquet file from the 'raw' container
3. Extracts metadata, labels, and images from the Parquet file
4. Uploads the extracted information to the 'out' container

## Key Components

- **BlobServiceClient**: Used to interact with Azure Blob Storage[1][3]
- **pandas**: Used to read and process the Parquet file
- **PIL (Python Imaging Library)**: Used to handle image data
- **argparse**: Enables command-line arguments for input blob and output prefix

## Main Function: extractParquetMetadata

This function performs the following tasks:

1. Downloads the Parquet file from the input container
2. Reads the Parquet file into a pandas DataFrame
3. Extracts and uploads DataFrame info as a text file
4. Extracts and uploads labels as a CSV file
5. Extracts and uploads individual images as PNG files

## Usage

Run the script with the following command-line arguments:

```bash
python script_name.py --inputBlob <input_blob_name> --outputPrefix <output_prefix>
```

## Security Note

The connection string in the script contains sensitive information. It's recommended to use more secure methods for handling credentials, such as environment variables or Azure Key Vault[2].

Citations:
[1] https://github.com/Huachao/azure-content/blob/master/articles/storage/storage-python-how-to-use-blob-storage.md
[2] https://learn.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-python
[3] https://learn.microsoft.com/en-us/python/api/overview/azure/storage-blob-readme?view=azure-python
[4] https://www.youtube.com/watch?v=bX-SSTCe2CY
[5] https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-python-get-started?tabs=azure-ad
[6] https://learn.microsoft.com/en-in/azure/storage/blobs/storage-blob-upload-python
[7] https://stackoverflow.com/questions/48881228/azure-blob-read-using-python
[8] https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-list-python

---
generated with perplexity.ai with the following prompt:

```text
generate a very short and simple doc for this script to be kept as markdown in the repo: extract_parquet_sas.py
```