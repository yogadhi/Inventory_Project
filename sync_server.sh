#!/bin/bash

# 1. Ambil State Terbaru dari GitHub
git fetch --all
git reset --hard origin/master

# 2. Hapus file/folder sisa yang tidak terdaftar di Git
# Kita abaikan folder mysql_data agar database TIDAK terhapus
git clean -fd --exclude=mysql_data/

# 3. Nuclear Rebuild Docker
# Hapus image lama agar Docker dipaksa COPY ulang folder build/web terbaru
docker compose down
docker rmi inventory_project-inventory-web inventory_project-inventory-api 2>/dev/null

# 4. Build Tanpa Cache dan Jalankan
docker compose build --no-cache
docker compose up -d

# 5. Verifikasi Jam File
echo ">>> Sync Selesai. Jam file terakhir:"
ls -lh inventory_web/build/web/main.dart.js