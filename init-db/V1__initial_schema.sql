-- =============================================================================
-- Database: inventory_db
-- Target: Docker Proxmox (MySQL 8.0)
-- =============================================================================

-- 1. Tabel Master: Kategori & Satuan
CREATE TABLE IF NOT EXISTS `kategori` (
  `kategori_id` int NOT NULL AUTO_INCREMENT,
  `nama_kategori` varchar(100) NOT NULL,
  `kode_singkatan` varchar(10) DEFAULT NULL,
  `is_active` tinyint DEFAULT '1',
  PRIMARY KEY (`kategori_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `satuan` (
  `satuan_id` int NOT NULL AUTO_INCREMENT,
  `nama_satuan` varchar(50) NOT NULL,
  `kode_satuan` varchar(10) DEFAULT NULL,
  `urutan_tingkat` int DEFAULT '0',
  `is_active` tinyint DEFAULT '1',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`satuan_id`),
  UNIQUE KEY `UQ_NamaSatuan` (`nama_satuan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 2. Tabel Partner: Pelanggan & Supplier
CREATE TABLE IF NOT EXISTS `pelanggan` (
  `pelanggan_id` char(36) NOT NULL,
  `nama_pelanggan` varchar(200) NOT NULL,
  `no_telp` varchar(20) DEFAULT NULL,
  `alamat` text,
  `limit_kredit` decimal(18,2) DEFAULT '0.00',
  `sisa_piutang` decimal(18,2) DEFAULT '0.00',
  `version` int DEFAULT '0',
  `is_active` tinyint DEFAULT '1',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(50) NOT NULL,
  `update_date` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`pelanggan_id`),
  UNIQUE KEY `UQ_Pelanggan_Nama` (`nama_pelanggan`,`no_telp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `supplier` (
  `supplier_id` char(36) NOT NULL,
  `nama_supplier` varchar(200) NOT NULL,
  `kategori_supplier` varchar(50) DEFAULT 'UMUM',
  `no_telp` varchar(20) DEFAULT NULL,
  `alamat` text,
  `sisa_hutang` decimal(18,2) DEFAULT '0.00',
  `is_active` tinyint DEFAULT '1',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(50) NOT NULL,
  PRIMARY KEY (`supplier_id`),
  UNIQUE KEY `UQ_Supplier_Nama` (`nama_supplier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 3. Tabel Produk & Konversi
CREATE TABLE IF NOT EXISTS `produk` (
  `produk_id` char(36) NOT NULL,
  `kode_barang` varchar(50) NOT NULL,
  `nama_barang` varchar(200) NOT NULL,
  `merk` varchar(100) DEFAULT NULL,
  `kategori_id` int DEFAULT NULL,
  `stok_total` int DEFAULT '0',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(50) NOT NULL,
  `is_active` tinyint DEFAULT '1',
  PRIMARY KEY (`produk_id`),
  UNIQUE KEY `UQ_KodeBarang` (`kode_barang`),
  CONSTRAINT `FK_Produk_Kategori` FOREIGN KEY (`kategori_id`) REFERENCES `kategori` (`kategori_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `satuan_konversi` (
  `konversi_id` char(36) NOT NULL,
  `produk_id` char(36) DEFAULT NULL,
  `nama_satuan` varchar(50) DEFAULT NULL,
  `rasio_ke_satuan_terkecil` int DEFAULT '1',
  `is_satuan_terkecil` tinyint DEFAULT '0',
  PRIMARY KEY (`konversi_id`),
  CONSTRAINT `FK_Satuan_Produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 4. Tabel Transaksi Stok (Masuk, Keluar, Mutasi, Opname)
CREATE TABLE IF NOT EXISTS `stok_keluar_header` (
  `keluar_id` char(36) NOT NULL,
  `no_nota` varchar(50) NOT NULL,
  `tanggal_keluar` datetime DEFAULT CURRENT_TIMESTAMP,
  `pelanggan_id` char(36) DEFAULT NULL,
  `total_omzet` decimal(18,2) DEFAULT '0.00',
  `create_by` varchar(50) NOT NULL,
  PRIMARY KEY (`keluar_id`),
  UNIQUE KEY `UQ_NoNota` (`no_nota`),
  CONSTRAINT `FK_Header_Pelanggan` FOREIGN KEY (`pelanggan_id`) REFERENCES `pelanggan` (`pelanggan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `stok_keluar_detail` (
  `detail_keluar_id` char(36) NOT NULL,
  `keluar_id` char(36) DEFAULT NULL,
  `produk_id` char(36) DEFAULT NULL,
  `jumlah_jual` int DEFAULT '0',
  `harga_jual_satuan` decimal(18,2) DEFAULT '0.00',
  PRIMARY KEY (`detail_keluar_id`),
  CONSTRAINT `FK_Detail_Header` FOREIGN KEY (`keluar_id`) REFERENCES `stok_keluar_header` (`keluar_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_Detail_Produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `stok_mutasi` (
  `mutasi_id` char(36) NOT NULL,
  `tanggal` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `produk_id` char(36) NOT NULL,
  `jenis` enum('MASUK','KELUAR','OPNAME','ADJUSTMENT') NOT NULL,
  `ref_id` char(36) NOT NULL,
  `qty` int NOT NULL,
  `saldo` int NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(50) NOT NULL,
  PRIMARY KEY (`mutasi_id`),
  CONSTRAINT `FK_Mutasi_Produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 5. Tabel Sistem (User, Role, Config, Log)
CREATE TABLE IF NOT EXISTS `sys_user` (
  `user_id` char(36) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UK_Username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `sys_audit_log` (
  `log_id" char(36) NOT NULL,
  `table_name` varchar(100) NOT NULL,
  `action` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `old_data` json DEFAULT NULL,
  `new_data` json DEFAULT NULL,
  `create_by` varchar(50) NOT NULL,
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;