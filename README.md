## Simple Python To-Do Application 🐍

This is a full-stack to-do list application built with **FastAPI** as the backend, served by **Uvicorn**, and a simple **HTML/JavaScript** frontend. The entire application is containerized with **Docker** and deployed to **Google Cloud Platform (GCP)** using **Terraform** and an automated CI/CD pipeline with **Harness**.

This project serves as a practical demonstration of modern DevOps practices, including:

  * **Infrastructure as Code (IaC):** Managing cloud resources with code.
  * **Containerization:** Packaging the application for consistent deployment.
  * **CI/CD Automation:** Automating the build, provision, and deploy process.

-----

### Project Structure

```
├── app/
│   ├── __init__.py
│   ├── main.py           # FastAPI application logic
│   └── models.py         # Data models for the to-do items
├── Dockerfile              # Instructions for building the Docker image
├── main.tf                 # Terraform code for GCP infrastructure
├── requirements.txt        # Python dependencies
└── README.md               # This file
```

-----

### Prerequisites

Before you can deploy this application, you need the following:

  * **Google Cloud Platform (GCP) Account:** With the **Compute Engine API** and **Cloud Storage API** enabled.
  * **GitHub Repository:** To host your application code and Terraform files.
  * **Docker Hub Account:** To store your application's Docker image.
  * **Harness Account:** To manage the automated pipeline.

-----

### Deployment Steps (Automated via Harness) 🚀

The entire deployment process is automated through a **Harness CI/CD pipeline**, which consists of two main stages.

#### **Stage 1: Build (CI Stage)**

This stage is responsible for building the Docker image of the application and pushing it to a container registry.

1.  **Code Fetch:** Harness connects to this GitHub repository and fetches the application code (`app/`, `Dockerfile`, `requirements.txt`).
2.  **Image Build:** It uses the `Dockerfile` to build a new Docker image for the to-do application.
3.  **Image Push:** The newly built image is tagged (e.g., `ganesh243/python-todo-app:latest`) and pushed to your **Docker Hub** registry.

#### **Stage 2: Provision & Deploy (IaCM Stage)**

This stage uses the **Infrastructure as Code Management (IaCM)** feature in Harness to provision the necessary infrastructure and deploy the application.

1.  **GCP Authentication:** Harness uses a pre-configured **GCP Connector** to authenticate with your Google Cloud account using a service account key.
2.  **Infrastructure Provisioning:**
      * Harness executes the `terraform apply` command using the `main.tf` file.
      * **Terraform** provisions a new **GCP Virtual Machine (VM)** instance.
      * It also creates all necessary networking resources, including a **VPC Network** and **Firewall Rules** to allow traffic for SSH and the application.
3.  **Automated Application Deployment:**
      * The `main.tf` file includes a `metadata_startup_script` on the VM.
      * As soon as the VM is created and starts for the first time, this script automatically runs.
      * The script installs Docker, pulls the latest Docker image from Docker Hub, and runs the container. The application is now live on the VM.

### How to Access the Application

After the pipeline successfully completes the `Provision & Deploy` stage, you can access the application:

1.  Go to the **Google Cloud Console**.
2.  Navigate to **Compute Engine \> VM instances**.
3.  Find the `todo-app-instance` and copy its **External IP** address.
4.  Open your web browser and navigate to `http://<YOUR_VM_EXTERNAL_IP>:8000`. You will see the interactive to-do list application.

-----

### Manual Commands (For Local Development)

If you need to run the application locally or for troubleshooting, you can use these commands:

  * **Build the Docker Image:**
    ```bash
    docker build -t your-dockerhub-username/python-todo-app .
    ```
  * **Run the Container Locally:**
    ```bash
    docker run -d -p 8000:8000 your-dockerhub-username/python-todo-app
    ```
