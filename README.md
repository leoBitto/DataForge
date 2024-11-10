# DataForge

![DataForge Logo](docs/assets/img/DataForge_logo.png)

**DataForge** is a comprehensive data management and processing platform designed for small and medium-sized enterprises (SMEs) looking for a simple and cost-effective solution for their data infrastructure. DataForge provides powerful tools to manage databases, automate workflows, and monitor the infrastructure.

## Key Features
- **Django Application**: A user-friendly application for easy data entry and visualization, allowing SMEs to access and manipulate data effortlessly.
- **"Silver" Database**: A database that stores structured data, ready for preliminary analysis and integration.
- **"Gold" Database**: An advanced database for optimized data ready for deeper analysis and machine learning.
- **Airflow**: Workflow automation tools for managing tasks and scheduling data pipelines.
- **Monitoring and Observability**: Grafana and Prometheus are integrated to monitor infrastructure and Kubernetes clusters, ensuring high availability and optimal performance.

## Project Goal
DataForge aims to provide an affordable and scalable data management solution based on open-source technologies and tailored to the needs of SMEs. With a microservices architecture supported by Kubernetes, the platform can be easily extended and customized.

## Infrastructure and Technologies Used
- **Django**: Main backend for data management and API support.
- **PostgreSQL**: Main databases (silver and gold) for data management.
- **Airflow**: Scheduler for orchestrating and automating complex data workflows.
- **Kubernetes**: For scalable deployment and container management.
- **Helm**: Kubernetes configuration and package management.
- **Grafana and Prometheus**: Infrastructure monitoring and metrics visualization.

## Getting Started
1. Follow the [Installation Guide](docs/installation.md) for setup and installation instructions.
2. Use the CI/CD workflows (see `.github/workflows`) to automate the build and deployment processes.
3. Configure the databases and the Django application as outlined in the [Deployment Guide](docs/deployment.md).

## Contributing
Contributions and feedback are welcome! Please check out [CONTRIBUTING.md](CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for more information on how to contribute.

---

