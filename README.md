Azure Dataset Processing Pipeline
---

![architecture](./docs/adf-data-pipeline.drawio.png)

### Setup and deployment

Make sure nix package manager is available on host os and run the following command to setting up the re-producible environment:

```bash
nix-shell
```

it will install Azure CLI, Python and requirements for jobs.

#### Deployment

Steps:

- Deploy all resources to Azure

---

#### Debug

- give IAM permission to log length of a path in a blob

#### Documentation

- [Proposal](./docs/PROPOSAL.md)
- [Setup]()
- Jobs
    - [extract](scripts/README.md)
