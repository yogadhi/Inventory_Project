-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: inventory_db
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `kategori`
--

DROP TABLE IF EXISTS `kategori`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kategori` (
  `kategori_id` int NOT NULL AUTO_INCREMENT,
  `nama_kategori` varchar(100) NOT NULL,
  `kode_singkatan` varchar(10) DEFAULT NULL,
  `is_active` tinyint DEFAULT '1',
  PRIMARY KEY (`kategori_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pelanggan`
--

DROP TABLE IF EXISTS `pelanggan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pelanggan` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produk`
--

DROP TABLE IF EXISTS `produk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produk` (
  `produk_id` char(36) NOT NULL,
  `kode_barang` varchar(50) NOT NULL,
  `nama_barang` varchar(200) NOT NULL,
  `merk` varchar(100) DEFAULT NULL,
  `kategori_id` int DEFAULT NULL,
  `kategori` varchar(100) DEFAULT NULL,
  `gramasi` int DEFAULT '0',
  `panjang` decimal(10,2) DEFAULT '0.00',
  `lebar` decimal(10,2) DEFAULT '0.00',
  `harga_kg` decimal(18,2) DEFAULT '0.00',
  `stok_minimal` int DEFAULT '0',
  `stok_total` int DEFAULT '0',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(50) NOT NULL,
  `update_date` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `update_by` varchar(50) DEFAULT NULL,
  `is_active` tinyint DEFAULT '1',
  `version` int DEFAULT '1',
  PRIMARY KEY (`produk_id`),
  UNIQUE KEY `UQ_KodeBarang` (`kode_barang`),
  KEY `FK_Produk_Kategori` (`kategori_id`),
  CONSTRAINT `FK_Produk_Kategori` FOREIGN KEY (`kategori_id`) REFERENCES `kategori` (`kategori_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produk_konversi`
--

DROP TABLE IF EXISTS `produk_konversi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produk_konversi` (
  `konversi_id` int NOT NULL AUTO_INCREMENT,
  `produk_id` char(36) NOT NULL,
  `satuan_id` int NOT NULL,
  `rasio_ke_terkecil` int NOT NULL,
  PRIMARY KEY (`konversi_id`),
  KEY `produk_id` (`produk_id`),
  KEY `satuan_id` (`satuan_id`),
  CONSTRAINT `produk_konversi_ibfk_1` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`),
  CONSTRAINT `produk_konversi_ibfk_2` FOREIGN KEY (`satuan_id`) REFERENCES `satuan` (`satuan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=796 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `satuan`
--

DROP TABLE IF EXISTS `satuan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `satuan` (
  `satuan_id` int NOT NULL AUTO_INCREMENT,
  `nama_satuan` varchar(50) NOT NULL,
  `kode_satuan` varchar(10) DEFAULT NULL,
  `urutan_tingkat` int DEFAULT '0',
  `is_active` tinyint DEFAULT '1',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`satuan_id`),
  UNIQUE KEY `UQ_NamaSatuan` (`nama_satuan`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `satuan_konversi`
--

DROP TABLE IF EXISTS `satuan_konversi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `satuan_konversi` (
  `konversi_id` char(36) NOT NULL,
  `produk_id` char(36) DEFAULT NULL,
  `nama_satuan` varchar(50) DEFAULT NULL,
  `rasio_ke_satuan_terkecil` int DEFAULT '1',
  `is_satuan_terkecil` tinyint DEFAULT '0',
  PRIMARY KEY (`konversi_id`),
  KEY `FK_Satuan_Produk` (`produk_id`),
  CONSTRAINT `FK_Satuan_Produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stok_keluar_detail`
--

DROP TABLE IF EXISTS `stok_keluar_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stok_keluar_detail` (
  `detail_keluar_id` char(36) NOT NULL,
  `keluar_id` char(36) DEFAULT NULL,
  `produk_id` char(36) DEFAULT NULL,
  `detail_masuk_id` char(36) DEFAULT NULL,
  `jumlah_jual` int DEFAULT '0',
  `harga_jual_satuan` decimal(18,2) DEFAULT '0.00',
  PRIMARY KEY (`detail_keluar_id`),
  KEY `idx_keluar` (`keluar_id`),
  KEY `idx_produk` (`produk_id`),
  CONSTRAINT `FK_Detail_Header` FOREIGN KEY (`keluar_id`) REFERENCES `stok_keluar_header` (`keluar_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_Detail_Produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stok_keluar_detail_tambahan`
--

DROP TABLE IF EXISTS `stok_keluar_detail_tambahan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stok_keluar_detail_tambahan` (
  `tambahan_id` char(36) NOT NULL,
  `detail_keluar_id` char(36) NOT NULL,
  `label` varchar(100) NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `is_potong` tinyint(1) DEFAULT '0',
  `ukuran_potong` varchar(50) DEFAULT NULL,
  `jumlah_potong` int DEFAULT NULL,
  PRIMARY KEY (`tambahan_id`),
  KEY `FK_tambahan_ke_detail` (`detail_keluar_id`),
  CONSTRAINT `FK_tambahan_ke_detail` FOREIGN KEY (`detail_keluar_id`) REFERENCES `stok_keluar_detail` (`detail_keluar_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stok_keluar_header`
--

DROP TABLE IF EXISTS `stok_keluar_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stok_keluar_header` (
  `keluar_id` char(36) NOT NULL,
  `no_nota` varchar(50) NOT NULL,
  `no_surat_jalan` varchar(50) DEFAULT NULL,
  `metode_pengiriman` varchar(50) DEFAULT 'Kirim',
  `tanggal_keluar` datetime DEFAULT CURRENT_TIMESTAMP,
  `pelanggan_id` char(36) DEFAULT NULL,
  `status_bayar` varchar(50) DEFAULT NULL,
  `is_lunas` tinyint(1) DEFAULT '0',
  `jatuh_tempo` datetime DEFAULT NULL,
  `total_omzet` decimal(18,2) DEFAULT '0.00',
  `uang_muka` decimal(18,2) DEFAULT '0.00',
  `sisa_piutang` decimal(18,2) DEFAULT '0.00',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(50) NOT NULL,
  `version` int DEFAULT '1',
  `update_date` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`keluar_id`),
  UNIQUE KEY `UQ_NoNota` (`no_nota`),
  KEY `FK_Header_Pelanggan` (`pelanggan_id`),
  CONSTRAINT `FK_Header_Pelanggan` FOREIGN KEY (`pelanggan_id`) REFERENCES `pelanggan` (`pelanggan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stok_keluar_pembayaran`
--

DROP TABLE IF EXISTS `stok_keluar_pembayaran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stok_keluar_pembayaran` (
  `pembayaran_id` char(36) NOT NULL,
  `keluar_id` char(36) NOT NULL,
  `tanggal_bayar` datetime DEFAULT CURRENT_TIMESTAMP,
  `jumlah_bayar` decimal(18,2) NOT NULL,
  `metode_bayar` varchar(50) DEFAULT 'Tunai',
  `keterangan` varchar(200) DEFAULT NULL,
  `create_by` varchar(50) NOT NULL,
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_date` datetime DEFAULT NULL,
  `update_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`pembayaran_id`),
  KEY `FK_pembayaran_ke_header` (`keluar_id`),
  CONSTRAINT `FK_pembayaran_ke_header` FOREIGN KEY (`keluar_id`) REFERENCES `stok_keluar_header` (`keluar_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stok_masuk_detail`
--

DROP TABLE IF EXISTS `stok_masuk_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stok_masuk_detail` (
  `detail_masuk_id` char(36) NOT NULL,
  `masuk_id` char(36) DEFAULT NULL,
  `produk_id` char(36) DEFAULT NULL,
  `jumlah_masuk` int DEFAULT '0',
  `satuan_digunakan` varchar(50) DEFAULT NULL,
  `harga_beli_satuan` decimal(18,2) DEFAULT '0.00',
  `sisa_stok_batch` int DEFAULT '0',
  PRIMARY KEY (`detail_masuk_id`),
  KEY `idx_produk_sisa` (`produk_id`,`sisa_stok_batch`),
  CONSTRAINT `FK_DetailMasuk_Produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stok_masuk_header`
--

DROP TABLE IF EXISTS `stok_masuk_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stok_masuk_header` (
  `masuk_id` char(36) NOT NULL,
  `no_po` varchar(50) NOT NULL,
  `supplier_id` char(36) DEFAULT NULL,
  `tanggal_masuk` datetime DEFAULT CURRENT_TIMESTAMP,
  `total_bayar` decimal(18,2) DEFAULT '0.00',
  `keterangan` text,
  `status_bayar` varchar(50) DEFAULT 'Lunas',
  `tanggal_jatuh_tempo` datetime DEFAULT NULL,
  `sisa_hutang` decimal(18,2) DEFAULT '0.00',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(50) NOT NULL,
  PRIMARY KEY (`masuk_id`),
  UNIQUE KEY `UQ_NoPO` (`no_po`),
  KEY `FK_Masuk_Supplier` (`supplier_id`),
  CONSTRAINT `FK_Masuk_Supplier` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stok_mutasi`
--

DROP TABLE IF EXISTS `stok_mutasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stok_mutasi` (
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
  KEY `idx_produk_tanggal` (`produk_id`,`tanggal`),
  CONSTRAINT `FK_Mutasi_Produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stok_opname`
--

DROP TABLE IF EXISTS `stok_opname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stok_opname` (
  `opname_id` char(36) NOT NULL,
  `tanggal_opname` datetime DEFAULT CURRENT_TIMESTAMP,
  `produk_id` char(36) DEFAULT NULL,
  `admin_id` char(36) DEFAULT NULL,
  `stok_sistem` int DEFAULT '0',
  `stok_fisik` int DEFAULT '0',
  `selisih` int GENERATED ALWAYS AS ((`stok_fisik` - `stok_sistem`)) VIRTUAL,
  `keterangan` text,
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(50) NOT NULL,
  PRIMARY KEY (`opname_id`),
  KEY `idx_opname_produk` (`produk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
  `supplier_id` char(36) NOT NULL,
  `nama_supplier` varchar(200) NOT NULL,
  `kategori_supplier` varchar(50) DEFAULT 'UMUM',
  `kontak_person` varchar(100) DEFAULT NULL,
  `no_telp` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `alamat` text,
  `npwp` varchar(50) DEFAULT NULL,
  `nama_bank` varchar(100) DEFAULT NULL,
  `no_rekening` varchar(50) DEFAULT NULL,
  `atas_nama` varchar(200) DEFAULT NULL,
  `termin_pembayaran` int DEFAULT '0',
  `sisa_hutang` decimal(18,2) DEFAULT '0.00',
  `keterangan` text,
  `is_active` tinyint DEFAULT '1',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(50) NOT NULL,
  `update_date` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `update_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`supplier_id`),
  UNIQUE KEY `UQ_Supplier_Nama` (`nama_supplier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_audit_log`
--

DROP TABLE IF EXISTS `sys_audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_audit_log` (
  `log_id` char(36) NOT NULL,
  `table_name` varchar(100) NOT NULL,
  `primary_key` char(36) NOT NULL,
  `action` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `old_data` json DEFAULT NULL,
  `new_data` json DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `create_by` varchar(50) NOT NULL,
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `IX_Audit_Table_Key` (`table_name`,`primary_key`),
  KEY `IX_Audit_User` (`create_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_key` varchar(50) NOT NULL,
  `config_value` text NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_permission`
--

DROP TABLE IF EXISTS `sys_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_permission` (
  `permission_id` varchar(50) NOT NULL,
  `permission_name` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  PRIMARY KEY (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` varchar(10) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_role_permission`
--

DROP TABLE IF EXISTS `sys_role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_permission` (
  `role_id` varchar(10) NOT NULL,
  `permission_id` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `FK_RP_Perm` (`permission_id`),
  CONSTRAINT `FK_RP_Perm` FOREIGN KEY (`permission_id`) REFERENCES `sys_permission` (`permission_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_RP_Role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_session_log`
--

DROP TABLE IF EXISTS `sys_session_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_session_log` (
  `session_id` char(36) NOT NULL,
  `username` varchar(50) NOT NULL,
  `login_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `logout_time` datetime DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `status` enum('ACTIVE','EXPIRED','LOGOUT') DEFAULT 'ACTIVE',
  `token` text,
  PRIMARY KEY (`session_id`),
  KEY `IX_Session_User` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` char(36) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UK_Username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` char(36) NOT NULL,
  `role_id` varchar(10) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `FK_UR_Role` (`role_id`),
  CONSTRAINT `FK_UR_Role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`role_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_UR_User` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
