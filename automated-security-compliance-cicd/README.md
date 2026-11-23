# Automated Security & Compliance in CI/CD Pipeline

A DevSecOps learning project that integrates automated security checks into a Jenkins CI/CD pipeline.

## Security workflow

1. Jenkins checks out the GitHub repository.
2. Trivy scans the source repository for vulnerabilities, misconfigurations and secrets.
3. Checkov scans Kubernetes manifests for infrastructure-as-code misconfigurations.
4. SonarQube analyzes source code quality and security issues.
5. Jenkins builds a Docker image.
6. Trivy scans the built image for HIGH and CRITICAL vulnerabilities.
7. Jenkins pauses for manual release approval.

## Tools

- Jenkins: pipeline orchestration
- Git/GitHub: source control
- Trivy: filesystem and container image scanning
- Checkov: Kubernetes/IaC security checks
- SonarQube: static code analysis
- Docker: container image build
- Bash: helper automation
- Kubernetes: deployment manifest security context

## Repository layout

```text
.
├── app/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
├── kubernetes/
│   ├── deployment.yaml
│   └── service.yaml
├── scripts/
│   ├── security-scan.sh
│   └── build-image.sh
├── security/
│   └── checkov-skip-checks.txt
├── Jenkinsfile
├── sonar-project.properties
└── README.md
```

## Prerequisites

Install/configure Git, Docker, Jenkins, Trivy, Checkov, SonarScanner and a SonarQube server. Jenkins agent must have Docker CLI/daemon access and the scanners available in PATH. Configure a SonarQube server in Jenkins with the name `SonarQube` (Manage Jenkins → System).

## Run local checks

From the project root:

```bash
docker build -t devsecops-demo:local ./app
trivy fs --scanners vuln,misconfig,secret --severity HIGH,CRITICAL .
checkov -d kubernetes --framework kubernetes
trivy image --severity HIGH,CRITICAL devsecops-demo:local
```

Run the app:

```bash
docker run --rm -p 5000:5000 devsecops-demo:local
```

Open `http://localhost:5000` and `http://localhost:5000/health`.

## Jenkins setup

1. Install Jenkins Pipeline, Git and SonarQube Scanner plugins.
2. Install Trivy, Checkov, SonarScanner and Docker on the Jenkins agent.
3. Configure a SonarQube server in Jenkins using the exact name `SonarQube`.
4. Create a Pipeline job pointing to this GitHub repository; set script path to `Jenkinsfile`.
5. Run the pipeline and review each scan report in the console output.

The sample pipeline fails on HIGH/CRITICAL Trivy findings. This is intentional: investigate and remediate findings rather than suppressing them. Checkov uses its default failure behavior.

## Important limitations

- This starter pipeline runs security scans and gates the release with manual approval. It does not publish an image to a registry or deploy to a Kubernetes cluster.
- SonarQube server and scanner must be configured correctly. A quality gate enforcement step can be added after configuring a project token and webhook.
- Exact findings depend on tool versions and vulnerability databases; scan results may change over time.
- Never commit passwords, tokens, private keys, kubeconfigs or cloud credentials.
- This is a learning/demo project, not a certification of regulatory compliance. Map checks to a specific compliance framework and validate results with qualified reviewers before making compliance claims.

## Interview explanation

"I developed a DevSecOps CI/CD pipeline using Jenkins. It integrates Trivy for filesystem, secret and container image scanning, Checkov for Kubernetes infrastructure-as-code checks, and SonarQube for static code analysis. The pipeline builds a Docker image only after source and manifest checks, scans the resulting image, and includes a manual approval gate before release. This shifts security checks earlier into the software delivery lifecycle."

## Resume bullet

Use after you have run the pipeline and can explain the scan results:

- Integrated Trivy, Checkov and SonarQube security checks into a Jenkins CI/CD pipeline to identify source, container and Kubernetes configuration risks before release.
