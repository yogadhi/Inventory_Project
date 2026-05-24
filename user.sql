-- ------------------------------------------------------
-- 1. TABEL UTAMA (MASTER TABLES)
-- ------------------------------------------------------

DROP TABLE IF EXISTS `sys_role_permission`;
DROP TABLE IF EXISTS `sys_permission`;
DROP TABLE IF EXISTS `sys_user_role`;
DROP TABLE IF EXISTS `sys_user`;
DROP TABLE IF EXISTS `sys_role`;

-- Struktur Tabel `sys_permission`
CREATE TABLE `sys_permission` (
  `permission_id` varchar(50) NOT NULL,
  `permission_name` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  PRIMARY KEY (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data Tabel `sys_permission`
LOCK TABLES `sys_permission` WRITE;
INSERT INTO `sys_permission` VALUES 
('CUST_CREATE','Tambah Customer','MASTER'),
('CUST_DELETE','Hapus Customer','MASTER'),
('CUST_READ','Lihat Customer','MASTER'),
('CUST_UPDATE','Edit Customer','MASTER'),
('DASHBOARD_VIEW','Lihat Dashboard','TRANSACTION'),
('PROD_CREATE','Tambah Produk','MASTER'),
('PROD_DELETE','Hapus Produk','MASTER'),
('PROD_READ','Lihat Produk','MASTER'),
('PROD_UPDATE','Edit Produk','MASTER'),
('STOK_IN','Input Stok Masuk','TRANSACTION'),
('STOK_OPNAME','Edit Stok Opname','TRANSACTION'),
('STOK_OUT','Input Stok Keluar','TRANSACTION'),
('STOK_OUT_VIEW','Lihat Stok Keluar','TRANSACTION'),
('SUPP_CREATE','Tambah Supplier','MASTER'),
('SUPP_DELETE','Hapus Supplier','MASTER'),
('SUPP_READ','Lihat Supplier','MASTER'),
('SUPP_UPDATE','Edit Supplier','MASTER'),
('USR_CREATE','Tambah User Baru','MASTER'),
('USR_DELETE','Hapus User','MASTER'),
('USR_READ','Lihat Daftar User','MASTER'),
('USR_UPDATE','Edit Data & Role User','MASTER');
UNLOCK TABLES;

-- Struktur Tabel `sys_role`
CREATE TABLE `sys_role` (
  `role_id` varchar(10) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data Tabel `sys_role`
LOCK TABLES `sys_role` WRITE;
INSERT INTO `sys_role` VALUES 
('ADM','Administrator'),
('OWN','Owner'),
('SPV','Supervisor Inventory');
UNLOCK TABLES;

-- Struktur Tabel `sys_user`
CREATE TABLE `sys_user` (
  `user_id` char(36) NOT NULL DEFAULT (UUID()), -- Dioptimalkan dengan auto-generate UUID di MySQL 8.0+
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UK_Username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data Tabel `sys_user`
LOCK TABLES `sys_user` WRITE;
INSERT INTO `sys_user` VALUES 
('32b9f5e0-3763-11f1-a333-8c8caa6fd643','superadmin','$2a$11$hm.iKGaaDnBuKNzs9DwBbu1Wc0aPrSNq.bWYyZ.4MWoj7RoV6jCJW','Super Administrator',1,'2026-04-14 01:04:21'),
('d7eeb7b4-5765-11f1-9c83-8c8caa6fd643','admin1','$2a$11$hm.iKGaaDnBuKNzs9DwBbu1Wc0aPrSNq.bWYyZ.4MWoj7RoV6jCJW','Admin 1',1,'2026-05-24 18:43:55'),
('f6a3d23b-5765-11f1-9c83-8c8caa6fd643','admin2','$2a$11$hm.iKGaaDnBuKNzs9DwBbu1Wc0aPrSNq.bWYyZ.4MWoj7RoV6jCJW','Admin 2',1,'2026-05-24 18:44:46');
UNLOCK TABLES;


-- ------------------------------------------------------
-- 2. TABEL RELASI / JUNCTION (MANY-TO-MANY)
-- ------------------------------------------------------

-- Struktur Tabel `sys_role_permission`
CREATE TABLE `sys_role_permission` (
  `role_id` varchar(10) NOT NULL,
  `permission_id` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `FK_RP_Perm` (`permission_id`),
  CONSTRAINT `FK_RP_Perm` FOREIGN KEY (`permission_id`) REFERENCES `sys_permission` (`permission_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_RP_Role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data Tabel `sys_role_permission`
LOCK TABLES `sys_role_permission` WRITE;
INSERT INTO `sys_role_permission` VALUES 
('ADM','CUST_CREATE'),('OWN','CUST_CREATE'),('SPV','CUST_CREATE'),
('ADM','CUST_DELETE'),('OWN','CUST_DELETE'),('SPV','CUST_DELETE'),
('ADM','CUST_READ'),('OWN','CUST_READ'),('SPV','CUST_READ'),
('ADM','CUST_UPDATE'),('OWN','CUST_UPDATE'),('SPV','CUST_UPDATE'),
('OWN','DASHBOARD_VIEW'),('SPV','DASHBOARD_VIEW'),
('OWN','PROD_CREATE'),('SPV','PROD_CREATE'),
('OWN','PROD_DELETE'),('SPV','PROD_DELETE'),
('OWN','PROD_READ'),('SPV','PROD_READ'),
('OWN','PROD_UPDATE'),('SPV','PROD_UPDATE'),
('ADM','STOK_IN'),('OWN','STOK_IN'),('SPV','STOK_IN'),
('OWN','STOK_OPNAME'),('SPV','STOK_OPNAME'),
('ADM','STOK_OUT'),('OWN','STOK_OUT'),('SPV','STOK_OUT'),
('ADM','STOK_OUT_VIEW'),('OWN','STOK_OUT_VIEW'),('SPV','STOK_OUT_VIEW'),
('ADM','SUPP_CREATE'),('OWN','SUPP_CREATE'),('SPV','SUPP_CREATE'),
('ADM','SUPP_DELETE'),('OWN','SUPP_DELETE'),('SPV','SUPP_DELETE'),
('ADM','SUPP_READ'),('OWN','SUPP_READ'),('SPV','SUPP_READ'),
('ADM','SUPP_UPDATE'),('OWN','SUPP_UPDATE'),('SPV','SUPP_UPDATE'),
('OWN','USR_CREATE'),('SPV','USR_CREATE'),
('OWN','USR_DELETE'),('SPV','USR_DELETE'),
('OWN','USR_READ'),('SPV','USR_READ'),
('OWN','USR_UPDATE'),('SPV','USR_UPDATE');
UNLOCK TABLES;

-- Struktur Tabel `sys_user_role`
CREATE TABLE `sys_user_role` (
  `user_id` char(36) NOT NULL,
  `role_id` varchar(10) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `FK_UR_Role` (`role_id`),
  CONSTRAINT `FK_UR_Role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`role_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_UR_User` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data Tabel `sys_user_role`
LOCK TABLES `sys_user_role` WRITE;
INSERT INTO `sys_user_role` VALUES 
('d7eeb7b4-5765-11f1-9c83-8c8caa6fd643','ADM'),
('f6a3d23b-5765-11f1-9c83-8c8caa6fd643','ADM'),
('32b9f5e0-3763-11f1-a333-8c8caa6fd643','SPV');
UNLOCK TABLES;