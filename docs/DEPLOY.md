Deploy
---

Following these steps in the order, will result in a setup comprising:

1. a Custom Resource Group
2. a Batch Account with a custom pool and two nodes
3. an Azure Data Factory account
4. an Azure Storage Account with 3 containers (raw, out, scripts)

### Custom Resource Group

```bash
make az-create-resource-group
```

### Batch Account with custom pool

```bash
make az-create-batch-account
```

```bash
make az-add-pool-to-batch-account
```

#### Custom Python Modules

- Add Requirements of the Nodes to `mypool.json`, for having a working node with Windows Data Science 2019, add all required python modules to be installed in the start task of nodes to line `29` of `mypool.json` file in `infra/batch/pool/` directory.