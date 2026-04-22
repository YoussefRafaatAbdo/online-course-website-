#!/bin/bash
# ============================================
# user_data.sh — EC2 Auto-Deployment Script
# Runs automatically when EC2 instance first boots
# Logs everything to: /var/log/ecourses-deploy.log
# ============================================

exec > /var/log/ecourses-deploy.log 2>&1
set -e

echo "=========================================="
echo "ECourses Auto-Deploy Starting..."
echo "Timestamp: $(date)"
echo "=========================================="

# --- Step 1: Update system packages ---
echo "[1/5] Updating system..."
yum update -y

# --- Step 2: Install Docker ---
echo "[2/5] Installing Docker..."
yum install -y docker git
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group so it can run docker without sudo
usermod -aG docker ec2-user

echo "Docker version: $(docker --version)"

# --- Step 3: Clone your GitHub repository ---
echo "[3/5] Cloning repository..."
cd /home/ec2-user

# Remove any previous clone
rm -rf online-course-website-

git clone ${repo_url} online-course-website-
cd online-course-website-

echo "Repository cloned successfully."
ls -la

# --- Step 4: Rename dockerfile → Dockerfile (Docker requires capital D) ---
echo "[4/5] Building Docker image..."
if [ -f "dockerfile" ] && [ ! -f "Dockerfile" ]; then
    mv dockerfile Dockerfile
    echo "Renamed: dockerfile → Dockerfile"
fi

# Build the image using nginx:alpine (fast, small ~25MB)
docker build -t ecourses:latest .

echo "Docker image built:"
docker images | grep ecourses

# --- Step 5: Run the container ---
echo "[5/5] Starting container..."

# Stop any existing container first
docker stop ecourses-app 2>/dev/null || true
docker rm ecourses-app 2>/dev/null || true

# Run on port 80 (mapped from container port 80)
docker run -d \
  --name ecourses-app \
  --restart always \
  -p 80:80 \
  ecourses:latest

echo "Container status:"
docker ps

echo "=========================================="
echo "Deployment Complete!"
echo "Website is running at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
echo "Timestamp: $(date)"
echo "=========================================="
