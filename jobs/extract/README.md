extract
---

#### parquet to csv and images for mnist

ref: https://huggingface.co/datasets/ylecun/mnist/tree/refs%2Fconvert%2Fparquet/mnist

commands:

```bash
python app.py -i data/raw/0000.parquet -o data/output/
```

```bash
docker build -t extract-job-data-pipeline ./extract/.
```

```bash
docker run --rm -v $(pwd)/data:/data extract-job-data-pipeline:latest app.py -i /data/raw/0000.parquet -o /data/output/
```

tag

```bash
docker tag extract-job-data-pipeline:latest datapipelinejobs.azurecr.io/jobs/extract
```

push to acr

```bash
az login
az acr login --name datapipelinejobs
```

```bash
docker push datapipelinejobs.azurecr.io/jobs/extract:latest
```
