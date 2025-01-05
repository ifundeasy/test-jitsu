# test-jitsu

I tested the Jitsu 2.8.5 (open source edition) by simulating sending events from the client app.

This performance report by setting 1 replica for each Jitsu service in the Kubernetes cluster.

As customer data platform, the results I did were quite impressive.

![alt text](./assets/replica-1-report-1.png?raw=true)
![alt text](./assets/replica-1-report-2.png?raw=true)

## Configuration

I ignored (set to infinite) the third-party configurations used by Jitsu such as:
- Postgres,
- Clickhouse,
- Kafka, and
- MongoDB

### Console (Webapp Nextjs)
Configuration:
* Replication: 1
* Request:
  - cpu: "512m"
  - memory: "512Mi"
* Limit:
  - cpu: "1"
  - memory: "1Gi"
  
### Sync Catalog Init (Bash)
Configuration:
* Replication: 1
* Request:
  - cpu: "128m"
  - memory: "64Mi"
* Limit:
  - cpu: "128m"
  - memory: "64Mi"

### Rotor (Backend Nodejs)
Configuration:
* Replication: 1
* Request:
  - cpu: "512m"
  - memory: "256Mi"
* Limit:
  - cpu: "1"
  - memory: "512Mi"

### Ingest (Backend Golang)
Configuration:
* Replication: 1
* Request:
  - cpu: "128m"
  - memory: "64Mi"
* Limit:
  - cpu: "256m"
  - memory: "128Mi"

### Bulker (Backend Golang)
Configuration:
* Replication: 1
* Request:
  - cpu: "128m"
  - memory: "64Mi"
* Limit:
  - cpu: "256m"
  - memory: "128Mi"
  
### Syncctl (Backend Golang)
Configuration:
* Replication: 1
* Request:
  - cpu: "128m"
  - memory: "64Mi"
* Limit:
  - cpu: "256m"
  - memory: "128Mi"

## Load test setup
```sh
# Using PyENV for python version manager
pyenv local 3.13.1
python --version

# Installation
pip install --upgrade pip setuptools wheel
python -m venv env

# Activation local env
source env/bin/activate

# Install dependency
pip install python-dotenv locust
```

## Run
```sh
locust -f jitsu.py
```