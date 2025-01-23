# Spring Boot JVM Optimizations Demo

This repository demonstrates various JVM optimization techniques, including **CDS (Class Data Sharing)**, **CRaC (Coordinated Restore at Checkpoint)**, **AOT (Ahead-of-Time Compilation)**, and **GraalVM Native Images**, using a modified version of the classic Spring Boot PetClinic application.

## Features

- **Spring Boot-based application** tailored for JVM optimization experiments.
- **Demonstrates key optimizations**:
    - **Class Data Sharing (CDS)**: Reduced startup time by sharing class metadata.
    - **CRaC (Coordinated Restore at Checkpoint)**: Optimized for fast restore from checkpoints.
    - **AOT (Ahead-of-Time Compilation)**: Improved startup and runtime performance.
    - **GraalVM Native Images**: Ultra-fast startup and minimal memory usage.
- **Monitoring and comparison tools**:
    - **Prometheus** for metrics collection.
    - **Grafana** dashboards for visualization.

## Repository Structure

```plaintext
.
├── Dockerfile                # Base Dockerfile
├── DockerfileAOT             # AOT-specific Docker configuration
├── DockerfileCDS             # CDS-specific Docker configuration
├── DockerfileCRaC            # CRaC-specific Docker configuration
├── DockerfileNative          # GraalVM Native Images Docker configuration
├── create_checkpoint.sh      # Script to create CRaC checkpoints
├── docker-compose.yml        # Docker Compose configuration
├── docker.sh                 # Utility script for Docker operations
├── monitoring/               # Prometheus and Grafana setup for monitoring
├── nginx/                    # Nginx configuration
├── postgres/                 # PostgreSQL configuration
├── restore_from_checkpoint.sh# Script to restore from CRaC checkpoints
├── run.sh                    # Main script to start the application
├── scripts/                  # Various helper scripts and tools
├── src/                      # Source code and resources
├── test/                     # Tests and JMeter configurations
└── pom.xml                   # Maven build file
```

## Getting Started

### Prerequisites

- **Docker** (>= 20.x)
- **Docker Compose** (>= 2.x)
- **Java Development Kit (JDK)** (>= 17)
- **Maven**

### Build and Run

#### Using Docker Compose

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/spring-boot-cds-appcds-crac-aot-graalvm-native-images-demo.git
   cd spring-boot-cds-appcds-crac-aot-graalvm-native-images-demo
   ```

2. Build and start the services:
   ```bash
   docker-compose up -d
   ```

3. Access the application:
    - Web UI: [http://localhost:8080](http://localhost:9090)
    - Grafana Dashboard: [http://localhost:23000](http://localhost:23000) (Default login: admin/admin)

#### Running Specific Configurations

- **CDS**: Use `DockerfileCDS`.
- **CRaC**: Create and restore checkpoints using `create_checkpoint.sh` and `restore_from_checkpoint.sh`.
- **AOT**: Use `DockerfileAOT`.
- **GraalVM Native Images**: Build and run using `DockerfileNative`.

## Monitoring Setup

The repository includes pre-configured Prometheus and Grafana setups for monitoring.

- **Prometheus Configuration**: `monitoring/config/prometheus.yml`
- **Grafana Dashboards**: `monitoring/config/grafana/provisioning/dashboards/`

## Contributions

Contributions are welcome! Please fork the repository, make changes, and submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE.txt).

## Acknowledgements

- Inspired by the [Spring PetClinic](https://github.com/spring-projects/spring-petclinic).
- Special thanks to the Spring Boot and GraalVM communities for their resources and support.
