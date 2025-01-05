extract
---

### parquet to csv and images for mnist

#### commands

```bash
python app.py -i data/raw/0000.parquet -o data/output/
```

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t extract-job-data-pipeline .
```

```bash
docker run --rm -v $(pwd)/data:/data extract-job-data-pipeline:latest app.py -i /data/raw/0000.parquet -o /data
```

#### tag

```bash
docker tag extract-job-data-pipeline:latest datapipelinejobs.azurecr.io/jobs/extract
```

#### push to acr

```bash
az login
az acr login --name datapipelinejobs
```

```bash
docker push datapipelinejobs.azurecr.io/jobs/extract:latest
```

---

ref: https://huggingface.co/datasets/ylecun/mnist/tree/refs%2Fconvert%2Fparquet/mnist
