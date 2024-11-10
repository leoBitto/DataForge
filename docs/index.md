# DataForge Documentation

Welcome to the official documentation for **DataForge**, an easy-to-use data management and processing platform for small and medium-sized enterprises (SMEs). This documentation will guide you through the installation, configuration, usage, and development of DataForge.

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
   - [Installation](docs/installation.md)
   - [Deploy the Application](docs/deployment.md)
3. [Project Structure](#project-structure)
4. [Usage](#usage)
   - [Base Project](docs/base.md)
   - [Silver and Gold Databases](docs/databases.md)
   - [Airflow Workflows](docs/airflow.md)
   - [Kubernetes & Helm](docs/kubernetes.md)
   - [Grafana & Prometheus](docs/monitoring.md)
5. [Contributing](docs/CONTRIBUTING.md)
6. [Code of Conduct](docs/CODE_OF_CONDUCT.md)
7. [License](docs/LICENSE.md)

## Introduction

**DataForge** is a data management platform designed to simplify the collection, storage, and processing of data for SMEs. It integrates Django, databases, and automated workflows to streamline the flow of information across systems.

DataForge uses a modular architecture with three main components:

- **Base Project**: Core functionalities and modules for managing data and processing workflows.
- **Silver Database**: Structured data storage, ideal for preliminary analysis and integration.
- **Gold Database**: Refined and processed data for advanced analysis and machine learning.

Additionally, DataForge leverages Kubernetes for scalable deployment, Helm for easier management of Kubernetes charts, and Grafana with Prometheus for monitoring your application and infrastructure.

## Getting Started

Start by installing the necessary dependencies and setting up the environment by following the [installation guide](docs/installation.md).

Once set up, deploy the application using the instructions in the [deployment guide](docs/deployment.md).

For local development, we recommend using **Docker** and **Kubernetes** to manage your application in a containerized environment. Follow the [Kubernetes setup](docs/kubernetes.md) to learn more.

## Project Structure

DataForge is organized in a modular way to provide flexibility and scalability. The project includes components for both backend functionality and data processing workflows. Learn more about how the project is structured in the following section.

## Usage

DataForge provides a set of features to manage your data flows and infrastructure:

- **[Base Project](docs/base.md)**: Core tools for managing data collection and storage.
- **[Silver and Gold Databases](docs/databases.md)**: Databases for structured and processed data.
- **[Airflow Workflows](docs/airflow.md)**: Automate data transformation and integration tasks.

### Kubernetes & Helm

DataForge is designed to be deployed on Kubernetes, which provides scalable and efficient container orchestration. The application is packaged into **Helm charts**, making it easy to manage and deploy the entire stack on Kubernetes.

In this section, you will find the necessary steps to deploy DataForge on Kubernetes, manage Helm releases, and scale the infrastructure.

- **[Kubernetes Setup](docs/kubernetes.md)**: Instructions for setting up and configuring Kubernetes for local or cloud-based deployment.
- **[Helm Chart](docs/helm.md)**: Guide on how to use Helm to install and manage DataForge's components.

### Grafana & Prometheus

Monitoring the performance of your Kubernetes cluster and application is essential. **Prometheus** is used to collect metrics, and **Grafana** is used to visualize them in beautiful and informative dashboards.

Follow the instructions to integrate Grafana and Prometheus into your Kubernetes setup to monitor both infrastructure and application metrics.

- **[Prometheus Setup](docs/prometheus.md)**: Learn how to set up Prometheus to collect metrics from your DataForge application.
- **[Grafana Setup](docs/grafana.md)**: Instructions for setting up Grafana to visualize and analyze the collected metrics.

## Contributing

We welcome contributions! Please refer to the [Contributing Guidelines](docs/CONTRIBUTING.md) for more information on how to get started.

## Code of Conduct

We strive for a welcoming and inclusive community. Please read our [Code of Conduct](docs/CODE_OF_CONDUCT.md) before contributing.

## License

DataForge is licensed under the [GPL License](docs/LICENSE.md). See the license file for details on how you can use and distribute the software.

