#!/usr/bin/env bash
set -euo pipefail

echo "== Trivy filesystem scan =="
trivy fs --scanners vuln,misconfig,secret --severity HIGH,CRITICAL --exit-code 1 .

echo "== Checkov IaC scan =="
checkov -d kubernetes --framework kubernetes --soft-fail-on MEDIUM
