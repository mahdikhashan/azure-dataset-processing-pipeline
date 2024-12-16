### AI/ML Dataset Processing Pipeline on Azure

The proposed solution aims to design a robust data processing pipeline for dataset ingestion, processing, 
and version control. The pipeline will ensure seamless data preparation and storage, leveraging Azure services 
and integrating with a possible data lake solution, such as Azure Data Lake Storage. Different dataset versions 
will be tagged and stored in an object storage system, enabling efficient management and accessibility.

### Goal

Facilitate data preparation for Machine Learning (ML) and Artificial Intelligence (AI) projects by leveraging 
a scalable possible data lake architecture in the Azure cloud environment.

### Scenarios

- Solution Developer (MLE):
Machine Learning Engineers (MLEs) will define and manage data preparation pipelines in an isolated environment. 
These pipelines will prepare datasets for consumption by Data Scientists and Data Analysts.

- Data Scientists and Analysts:
Data Scientists and Analysts will utilize automated pipelines to preprocess data. 
They can integrate custom processing scripts, implement data transformations, 
and register processed datasets in the data lake with version tags for easy tracking and reproducibility.

### Architecture

```text
+-----------------------+       +---------------------+      +-------------------+
| External Data Source  |       | Azure Data Factory  |      | Azure Blob Storage|
| (MNIST Public Dataset)|  ---> |   (Ingestion &      | ---> |    (Raw Storage)  |
+-----------------------+       |    Processing)      |      +-------------------+
                                +---------------------+                |
                                    |                                  v
                                    v                        +-------------------+
                                +-------------------+       | Azure Functions   |
                                | ADF Pipeline      | ----> | (Data Processing) |
                                | (Transformation)  |       +-------------------+
                                +-------------------+                |
                                    |                                v
                                    v                        +-------------------+
                                +-------------------+       |    Azure Blob     |
                                | Azure Blob Storage| ----> |  (Processed Data) |
                                |(Processed Dataset)|       +-------------------+
                                +-------------------+                |
                                                                     v
                                                          +-------------------+
                                                          |  End Users        |
                                                          |(Data Scientists,  |
                                                          | Data Analysts)    |
                                                          +-------------------+
```

### Technology / Implementation

Data Ingestion: Leverage Azure Data Factory for orchestrating the ingestion of raw datasets into the pipeline.

Data Processing: Use Azure Functions to handle data transformations and apply custom processing scripts.

Data Storage and Versioning: Use Azure Blob Storage or Azure Data Lake Storage.

Automation: Employ GitHub Actions pipelines for continuous integration and deployment (CI/CD) of the data processing workflows.

### Milestones

#### Phase 1:

Define data ingestion and processing workflows.
Use Azure Blob Storage for version control.
Deploy a basic pipeline for data ingestion and versioned storage.

#### Phase 2:

Automate processing pipelines using Azure Functions.
Provide templates for custom processing scripts.
Test and validate end-to-end functionality.

#### Phase 3:

Enable self-service access for Data Scientists and Analysts.
Implement monitoring and logging for pipelines using Azure Monitor.
Document practices and usage guidelines.

#### Extra Work:

After implementing the solution, in case of having extra time left, I'll try to tackle the following goals:

- Conduct training sessions for stakeholders / Knowledge share.
- Optimize pipeline performance and scalability / Implement triggers and event handling.
- Provide a reusable solution for other Azure ML/AI projects.
- Add Sanity / Acceptance tests for the solution

### Estimation

For a student working part-time (15-20 hrs/week), with 2 years of experience, the implementation timeline could be:

- Planning and Design (2–3 Days)
    - Refine detailed requirements for data processing (input/output formats, transformations).
    - Finalize architecture, including Azure Functions, ADF pipeline, and storage integration.
    - Select PyTorch transformations or processing logic.
    - Determine tools, dependencies, and Azure Function execution plans (e.g., Enterprise plan if existed).

- Environment Setup (3 Days)
    - Create Azure Function App (Python runtime) in the Azure portal.
    - Set up Azure Data Factory and define a skeleton pipeline.
    - Provision Azure Blob Storage or Data Lake for input/output datasets.
    - Set up a GitHub repository and connect it to Azure for CI/CD.

- Development and Testing (1–1.5 Weeks)
    - Days 1–4:
        - Develop PyTorch-based data transformation logic in Azure Functions.
        - Test the function locally and deploy it to Azure.
    - Days 5–7:
        - Integrate the Azure Function with Blob Storage for input/output processing.
        - Build a working Azure Data Factory pipeline with the Azure Function Activity.
        - Conduct end-to-end testing with small datasets, focusing on PyTorch transformations.
        - Refine error handling and logging.

- Scaling and Optimization (3–5 Days)
    - Run tests with larger datasets to evaluate performance. 
    - Optimize Azure Function configurations (e.g., memory allocation, execution plan).
    - Add monitoring tools like Azure Monitor and Application Insights for troubleshooting.
    - Evaluate and refine the cost-effectiveness of the solution.

- Documentation (2–3 Days)
    - Write clear documentation for setting up and using the data processing pipeline.
    - Add example scripts and workflows for data scientists/analysts to integrate with the pipeline.

- Evaluation (2–3 Days)
    - Validate the solution with sample users (e.g., data scientists or analysts).
    - Collect and address feedback for final adjustments.
    - Conduct a knowledge transfer session or write a detailed handover guide.

Which the estimated timeline could be improved with further training and more experience.
