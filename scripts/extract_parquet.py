import io
from io import StringIO
import os
import argparse
import pandas as pd
import numpy as np
from PIL import Image


connectionString = "DefaultEndpointsProtocol=https;AccountName=mypipelinestorageaccount;AccountKey=AfuOJyIUIYFN1+pW5vVqHgkTNbvcsYATisy7DfBqilUD3Kx5qBQOHC1MVM6Om5mLBflbR0W/hRv0+ASt78zQIw==;EndpointSuffix=core.windows.net"
containerName = "out"
outputFolder = "/"


def extractParquetMetadata(file_path, output_dir):
    df = pd.read_parquet(file_path)

    output = createOutputFolder(output_dir)

    images_dir = os.path.join(output, "images")
    labels_file = os.path.join(output, "labels.csv")
    info_file = os.path.join(output, "info.txt")

    with open(info_file, "w") as f:
        buffer = StringIO()
        df.info(buf=buffer)
        dataframe_info = buffer.getvalue()
        f.write(dataframe_info)

    os.makedirs(images_dir, exist_ok=True)

    labels = df["label"].values
    with open(labels_file, "w") as f:
        f.write("Index,Label\n")  # Header
        for idx, label in enumerate(labels):
            f.write(f"{idx},{label}\n")

    for idx, image_data in enumerate(df["image"]):
        image_array = np.array(Image.open(io.BytesIO(image_data["bytes"])))

        image = Image.fromarray(image_array)
        image.save(os.path.join(images_dir, f"image_{idx}.png"))

    print(
        f"Extraction complete! Metadata in '{info_file}', labels in '{labels_file}', and images in '{images_dir}'."
    )


def createOutputFolder(outputPath: str):
    outputFolder = f"{outputPath}/output"

    try:
        if os.path.exists(outputFolder):
            pass
        else:
            os.mkdir(outputFolder)
    except Exception as e:
        raise RuntimeError(f"Error: {e.__class__()}")
    return outputFolder


if __name__ == "__main__":
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument(
            "--inputFile", "-i", help="Set the file path for the raw bag file."
        )
        parser.add_argument(
            "--outputPath", "-o", help="Set the output path for the extracted contents."
        )
        args = parser.parse_args()
        extractParquetMetadata(args.inputFile, args.outputPath)
    except Exception:
        raise RuntimeError("failed to extract metadata")
