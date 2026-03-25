# Deploy Protocol — Under Construction Page

## Server Information

| รายการ | ค่า |
|--------|-----|
| **Production Server (SSH)** | `ssh root@10.10.8.151` (private IP) |
| **Production Public IP** | `172.16.160.17` |
| **Web URL** | `http://172.16.160.17:4004` |
| **Admin URL** | `http://172.16.160.17:4005` |
| **Web Port** | 4004 |
| **Admin Port** | 4005 |
| **Container Name** | `cdd-under-construction` |
| **Network** | `cdd-network` (external) |

## ไฟล์ในโปรเจกต์

| ไฟล์ | คำอธิบาย |
|------|----------|
| `index.html` | หน้า Under Construction สำหรับ Web Dashboard (สีน้ำเงิน) |
| `admin.html` | หน้า Under Construction สำหรับ Admin Dashboard (สีม่วง) |
| `favicon.svg` | Favicon |
| `nginx.conf` | Nginx config — port 80 (web), port 81 (admin) |
| `Dockerfile` | nginx:alpine + static files |
| `docker-compose.yml` | container config: 4004->80, 4005->81 |
| `deploy.sh` | Script build & run บน server |
| `deploy-production.sh` | Script deploy จาก local ไป production |

## วิธี Deploy ไป Production

### แบบ Auto (ใช้ script)

```bash
cd /Users/chalermpol/repo/cdd-dashboard/cdd-under-construction
./deploy-production.sh
```

### แบบ Manual (ทีละขั้นตอน)

**ขั้นตอนที่ 1:** Copy ไฟล์ไปยัง server

```bash
ssh root@10.10.8.151 "mkdir -p /root/cdd-under-construction"

scp index.html admin.html favicon.svg nginx.conf Dockerfile docker-compose.yml deploy.sh \
  root@10.10.8.151:/root/cdd-under-construction/
```

**ขั้นตอนที่ 2:** SSH เข้า server แล้ว build

```bash
ssh root@10.10.8.151
cd /root/cdd-under-construction
chmod +x deploy.sh
./deploy.sh
```

**ขั้นตอนที่ 3:** ตรวจสอบ

```bash
docker ps | grep cdd-under-construction
curl http://localhost:4004   # Web
curl http://localhost:4005   # Admin
```

## Nginx Reverse Proxy (Host)

Production server มี nginx host ทำ reverse proxy:

- Config: `/etc/nginx/sites-enabled/smartbmndashboard`
- HTTP :80 -> redirect HTTPS
- HTTPS :443 -> `proxy_pass http://127.0.0.1:4004` (frontend)
- `/api/` -> `proxy_pass http://127.0.0.1:18080` (API Gateway)
- SSL cert: `/etc/ssl/certs/smartbmndashboard.crt`
- Domain: `smartbmndashboard.cdd.go.th`

**หมายเหตุ:** เดิม frontend proxy ชี้ไป port 3001 — เปลี่ยนเป็น 4004 แล้ว

## วิธีกลับไปใช้ Dashboard ตัวจริง

```bash
ssh root@10.10.8.151

# หยุด under construction
cd /root/cdd-under-construction && docker compose down

# เริ่ม dashboard ตัวจริง
cd /root/repo/cdd-dashboard/cdd-dashboard-web && ./deploy.sh
cd /root/repo/cdd-dashboard/cdd-dashboard-admin && ./deploy.sh
```

## วิธีทดสอบ Local

```bash
# เปิดดูไฟล์ HTML ตรง (ไม่ต้องใช้ Docker)
open index.html   # Web
open admin.html   # Admin

# หรือรันผ่าน Docker
docker compose up -d --build
# เปิด http://localhost:4004 (Web)
# เปิด http://localhost:4005 (Admin)
```

## หมายเหตุ

- Container name เปลี่ยนเป็น `cdd-under-construction` — ต้อง stop container `cdd-dashboard-web` และ `cdd-dashboard-admin` ก่อน deploy
- ใช้ `cdd-network` (external) — ต้องมี network นี้อยู่แล้วบน server
- Dockerfile ใช้ `nginx:alpine` เท่านั้น (ไม่ต้อง build Node.js) — deploy เร็ว
- container เดียวรองรับทั้ง Web (port 80->4004) และ Admin (port 81->4005)
