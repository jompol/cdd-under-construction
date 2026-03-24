#!/bin/bash
set -e

SERVER="root@10.10.8.151"
REMOTE_PATH="/root/cdd-under-construction"

echo "=== Deploying Under Construction to Production ==="

# Step 1: Create directory on server if not exists
echo "[1/3] Preparing remote directory..."
ssh $SERVER "mkdir -p $REMOTE_PATH"

# Step 2: Copy files to server
echo "[2/3] Copying files..."
scp index.html favicon.svg nginx.conf Dockerfile docker-compose.yml deploy.sh \
  $SERVER:$REMOTE_PATH/

# Step 3: Build and start container
echo "[3/3] Building and starting container..."
ssh $SERVER "cd $REMOTE_PATH && chmod +x deploy.sh && ./deploy.sh"

echo ""
echo "=== Done! Under Construction page is live on port 4004 ==="
echo ""
echo "To restore the real dashboard later:"
echo "  ssh $SERVER 'cd $REMOTE_PATH && docker compose down'"
echo "  ssh $SERVER 'cd /root/repo/cdd-dashboard/cdd-dashboard-web && ./deploy.sh'"
