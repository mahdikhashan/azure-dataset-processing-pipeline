from azure.storage.blob import BlobServiceClient
import pandas as pd
import io
import argparse

parser = argparse.ArgumentParser(
    description="Process iris dataset and upload to Azure Blob Storage."
)
parser.add_argument("input_blob", type=str, help="Name of the input blob")
parser.add_argument("output_blob", type=str, help="Name of the output blob")
args = parser.parse_args()

connectionString = "DefaultEndpointsProtocol=https;AccountName=mypipelinestorageaccount;AccountKey=AfuOJyIUIYFN1+pW5vVqHgkTNbvcsYATisy7DfBqilUD3Kx5qBQOHC1MVM6Om5mLBflbR0W/hRv0+ASt78zQIw==;EndpointSuffix=core.windows.net"
inputContainerName = "raw"
outputContainerName = "out"
inputBlobName = args.input_blob
outputBlobName = args.output_blob

try:
    blob_service_client = BlobServiceClient.from_connection_string(
        conn_str=connectionString
    )

    input_container_client = blob_service_client.get_container_client(
        inputContainerName
    )

    input_blob_client = input_container_client.get_blob_client(inputBlobName)
    blob_data = input_blob_client.download_blob().readall()

    df = pd.read_csv(io.BytesIO(blob_data))

    df_setosa = df[df["Species"] == "setosa"]

    output_buffer = io.StringIO()
    df_setosa.to_csv(output_buffer, index=False)

    output_container_client = blob_service_client.get_container_client(
        outputContainerName
    )

    output_blob_client = output_container_client.get_blob_client(outputBlobName)

    output_blob_client.upload_blob(output_buffer.getvalue(), overwrite=True)

    print(f"Successfully processed and uploaded {outputBlobName}")

except Exception as e:
    print(f"An error occurred: {str(e)}")

finally:
    if "output_buffer" in locals():
        output_buffer.close()
