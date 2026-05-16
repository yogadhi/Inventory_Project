#!/bin/bash

# 1. Bersihkan Index Git agar sinkronisasi mulai dari nol
git rm -rf --cached .

# 2. Tambahkan SEMUA file yang ada di folder saat ini
# Ini akan mengambil semua folder (api, web, init-db, dll) secara otomatis
# Kita gunakan '.' tapi kita exclude folder data agar tidak error socket
git add .

# 3. PAKSA Tambahkan folder build web (Hasil Flutter)
# Perintah ini wajib tetap ada karena folder build biasanya masuk .gitignore
git add -f inventory_web/build/web/

# 4. REMOVE manual folder data jika tidak sengaja masuk (Pencegahan Error)
# Ini agar script tidak crash jika ada file socket mysql di lokal
git rm -r --cached mysql_data/ 2>/dev/null

# 5. Commit dengan pesan otomatis menggunakan jam sekarang
git commit -m "FORCE UPDATE: $(date +'%Y-%m-%d %H:%M:%S')"

# 6. Force Push ke GitHub (Menimpa sejarah lama)
git push origin master --force

echo "----------------------------------------------------"
echo ">>> PUSH BERHASIL: GitHub sudah identik dengan Lokal."
echo ">>> Sekarang jalankan sync_server.sh di Proxmox."
echo "----------------------------------------------------"