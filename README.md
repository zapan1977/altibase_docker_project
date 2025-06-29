# Altibase HDB on Rocky Linux 8.10 (Dockerized)

---

This repository provides a Docker setup for running **Altibase HDB 7.1.0.9.0** on a **Rocky Linux 8.10** base image. It aims to offer a consistent and isolated environment for Altibase development, testing, or lightweight production deployments.

## Table of Contents

-   [Features](#features)
-   [Prerequisites](#prerequisites)
-   [Installation](#installation)
    -   [1. Prepare Altibase Installation Files](#1-prepare-altibase-installation-files)
    -   [2. Build the Docker Image](#2-build-the-docker-image)
-   [Usage](#usage)
    -   [1. Run the Altibase Container](#1-run-the-altibase-container)
    -   [2. Connect to Altibase](#2-connect-to-altibase)
    -   [3. Stop and Remove the Container](#3-stop-and-remove-the-container)
-   [Persistence (Optional)](#persistence-optional)
-   [Customization](#customization)
-   [Troubleshooting](#troubleshooting)
-   [Contributing](#contributing)
-   [License](#license)

---

## Features

* **Rocky Linux 8.10 Base**: Leverages a stable and well-supported enterprise-grade Linux distribution.
* **Dockerized Deployment**: Ensures consistent and isolated Altibase environments.
* **Automated Setup**: Streamlined installation process via `Dockerfile` and custom scripts.
* **Port Mapping**: Exposes Altibase's default port (20300) for easy access.
* **Start/Stop Scripts**: Includes simple scripts for managing the Altibase server within the container.

## Prerequisites

Before you begin, ensure you have the following installed on your system:

* **Docker**: [Install Docker Engine](https://docs.docker.com/engine/install/)
* **Altibase Installation Package**: You will need the Altibase HDB installation `.tar.gz` file (e.g., `Altibase_HDB_7_1_0_9_0_Linux_64bit.tar.gz`). This file must be obtained from Altibase's official channels.

## Installation

### 1. Prepare Altibase Installation Files

1.  Create a directory for your project (e.g., `altibase-docker`).
2.  Place your Altibase installation `.tar.gz` file inside this directory.
3.  Create the following files in the same directory:
    * `Dockerfile`
    * `install_altibase.sh`
    * `start_altibase.sh`

    Your directory structure should look like this:

    ```
    altibase-docker/
    ├── Dockerfile
    ├── Altibase_HDB_7_1_0_9_0_Linux_64bit.tar.gz  # Altibase install file
    ├── install_altibase.sh
    └── start_altibase.sh
    ```

    **NOTE:** The `Dockerfile`, `install_altibase.sh`, and `start_altibase.sh` content should be as provided in the previous step of our conversation.

### 2. Build the Docker Image

Navigate to your `altibase-docker` directory in your terminal and run the following command to build the Docker image:

```bash
docker build -t altibase-rockylinux:7.1.0.9.0 .
