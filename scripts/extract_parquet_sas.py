import io
from io import StringIO
import argparse
import pandas as pd
import numpy as np
from PIL import Image
from azure.storage.blob import BlobServiceClient

connectionString = "DefaultEndpointsProtocol=https;AccountName=mypipelinestorageaccount;AccountKey=AfuOJyIUIYFN1+pW5vVqHgkTNbvcsYATisy7DfBqilUD3Kx5qBQOHC1MVM6Om5mLBflbR0W/hRv0+ASt78zQIw==;EndpointSuffix=core.windows.net"
inputContainerName = "raw"
outputContainerName = "out"


def extractParquetMetadata(blob_service_client, input_blob_name, output_blob_prefix):
    input_blob_client = blob_service_client.get_blob_client(
        container=inputContainerName, blob=input_blob_name
    )
    blob_data = input_blob_client.download_blob().readall()

    df = pd.read_parquet(io.BytesIO(blob_data))

    info_buffer = StringIO()
    df.info(buf=info_buffer)
    dataframe_info = info_buffer.getvalue()

    labels = df["label"].values
    labels_buffer = StringIO()
    labels_buffer.write("Index,Label\n")
    for idx, label in enumerate(labels):
        labels_buffer.write(f"{idx},{label}\n")

    output_container_client = blob_service_client.get_container_client(
        outputContainerName
    )

    output_container_client.upload_blob(
        name=f"{output_blob_prefix}/info.txt", data=dataframe_info, overwrite=True
    )
    output_container_client.upload_blob(
        name=f"{output_blob_prefix}/labels.csv",
        data=labels_buffer.getvalue(),
        overwrite=True,
    )

    for idx, image_data in enumerate(df["image"]):
        image_array = np.array(Image.open(io.BytesIO(image_data["bytes"])))
        image = Image.fromarray(image_array)
        image_buffer = io.BytesIO()
        image.save(image_buffer, format="PNG")
        image_buffer.seek(0)
        output_container_client.upload_blob(
            name=f"{output_blob_prefix}/images/image_{idx}.png",
            data=image_buffer,
            overwrite=True,
        )

    print(
        f"Extraction complete! Metadata, labels, and images uploaded to '{outputContainerName}/{output_blob_prefix}'."
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--inputBlob", "-i", help="Name of the input blob in the 'raw' container"
    )
    parser.add_argument(
        "--outputPrefix", "-o", help="Prefix for output blobs in the 'out' container"
    )
    args = parser.parse_args()

    try:
        blob_service_client = BlobServiceClient.from_connection_string(connectionString)
        extractParquetMetadata(blob_service_client, args.inputBlob, args.outputPrefix)
    except Exception as e:
        raise RuntimeError(f"Failed to extract metadata: {str(e)}")
