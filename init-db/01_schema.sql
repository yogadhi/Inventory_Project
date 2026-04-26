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
) ENGINE=InnoDB AUTO_INCREMENT=784 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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

--
-- Dumping routines for database 'inventory_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_eksekusi_stok_opname` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eksekusi_stok_opname`(
    IN p_produk_id CHAR(36),
    IN p_stok_fisik INT,
    IN p_admin_id CHAR(36),
    IN p_keterangan TEXT
)
BEGIN
    DECLARE v_stok_sistem INT;
    DECLARE v_selisih INT;
    DECLARE v_opname_id CHAR(36);

    -- 1. Ambil stok terakhir dari sistem
    SELECT IFNULL(stok_total, 0) INTO v_stok_sistem 
    FROM produk WHERE produk_id = p_produk_id;

    -- 2. Hitung selisih (Fisik - Sistem)
    SET v_selisih = p_stok_fisik - v_stok_sistem;
    SET v_opname_id = UUID();

    -- 3. Catat Riwayat Opname
    INSERT INTO stok_opname (opname_id, tanggal_opname, produk_id, admin_id, stok_sistem, stok_fisik, keterangan, create_by)
    VALUES (v_opname_id, NOW(), p_produk_id, p_admin_id, v_stok_sistem, p_stok_fisik, p_keterangan, p_admin_id);

    -- 4. Catat ke Mutasi (Saldo akhir menjadi p_stok_fisik)
    INSERT INTO stok_mutasi (mutasi_id, produk_id, tanggal, jenis, ref_id, qty, saldo, keterangan)
    VALUES (UUID(), p_produk_id, NOW(), 'OPNAME', v_opname_id, v_selisih, p_stok_fisik, p_keterangan);

    -- 5. Sinkronisasi Stok Total di Master Produk
    UPDATE produk SET stok_total = p_stok_fisik WHERE produk_id = p_produk_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_kartu_stok` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_kartu_stok`(
    IN p_produk_id CHAR(36),
    IN p_tanggal_mulai DATETIME,
    IN p_tanggal_selesai DATETIME
)
BEGIN
    DECLARE v_saldo_awal INT DEFAULT 0;

    -- 1. Hitung Saldo Awal sebelum rentang pencarian
    SELECT IFNULL(SUM(qty), 0) INTO v_saldo_awal
    FROM stok_mutasi
    WHERE produk_id = p_produk_id AND tanggal < p_tanggal_mulai;

    -- 2. Tampilkan Kartu Stok dengan baris Saldo Awal + Running Total
    SELECT * FROM (
        -- BARIS SALDO AWAL
        SELECT 
            p_tanggal_mulai AS tanggal, 
            NULL AS create_date,
            'AWAL' AS jenis, 
            '-' AS ref_id,
            0 AS qty_masuk,
            0 AS qty_keluar,
            v_saldo_awal AS saldo, 
            'Saldo Awal Periode' AS keterangan,
            '-' AS create_by,
            0 AS sort_priority -- Prioritas 0 agar selalu di paling atas
            
        UNION ALL
        
        -- BARIS TRANSAKSI MUTASI
        SELECT 
            t.tanggal, 
            t.create_date, 
            t.jenis, 
            t.ref_id,
            t.qty_masuk,
            t.qty_keluar,
            (v_saldo_awal + SUM(t.raw_qty) OVER (ORDER BY t.tanggal ASC, t.create_date ASC, t.raw_qty DESC)) AS saldo,
            t.keterangan,
            t.create_by,
            1 AS sort_priority -- Prioritas 1 untuk transaksi
        FROM (
            SELECT 
                tanggal, create_date, jenis, ref_id, qty AS raw_qty,
                CASE WHEN qty > 0 THEN qty ELSE 0 END AS qty_masuk,
                CASE WHEN qty < 0 THEN ABS(qty) ELSE 0 END AS qty_keluar,
                keterangan, create_by
            FROM stok_mutasi
            WHERE produk_id = p_produk_id 
              AND tanggal BETWEEN p_tanggal_mulai AND p_tanggal_selesai
        ) t
    ) final_result
    ORDER BY sort_priority ASC, tanggal ASC, create_date ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_produk_price_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_produk_price_list`(
    IN p_untung_rim_percent DECIMAL(5,2),
    IN p_untung_eceran_percent DECIMAL(5,2)
)
BEGIN
    DECLARE v_multiplier_rim DECIMAL(10,4);
    DECLARE v_multiplier_eceran DECIMAL(10,4);
    
    -- 1. Set multiplier (Default ke 1.00 jika parameter null)
    SET v_multiplier_rim = 1 + (IFNULL(p_untung_rim_percent, 1.00) / 100);
    SET v_multiplier_eceran = 1 + (IFNULL(p_untung_eceran_percent, 1.00) / 100);

    -- 2. Query Utama
    SELECT 
        CAST(p.produk_id AS CHAR) AS produk_id, 
        p.kode_barang, 
        p.nama_barang, 
        p.merk, 
        k.nama_kategori AS kategori,
        p.gramasi, 
        p.panjang, 
        p.lebar, 
        p.harga_kg, 
        p.stok_minimal, 
        p.stok_total,
        p.version, -- <--- WAJIB DITAMBAHKAN UNTUK OPTIMISTIC CONCURRENCY
        p.create_date, 
        p.create_by, 
        p.update_date, 
        p.update_by,
        -- Subquery untuk mengambil list konversi dalam format JSON
        (
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'konversi_id', CAST(pk.konversi_id AS CHAR),
                    'produk_id', pk.produk_id,
                    'nama_satuan', s.nama_satuan,
                    'rasio_ke_terkecil', pk.rasio_ke_terkecil,
                    'is_satuan_terkecil', IF(pk.rasio_ke_terkecil = (
                        SELECT MIN(rasio_ke_terkecil) 
                        FROM produk_konversi 
                        WHERE produk_id = p.produk_id
                    ), 1, 0)
                )
            )
            FROM produk_konversi pk 
            INNER JOIN satuan s ON s.satuan_id = pk.satuan_id AND s.is_active = 1
            WHERE pk.produk_id = p.produk_id
        ) AS conversions_raw,
        -- Kalkulasi Harga Modal Rim
        CAST(((p.panjang * p.lebar * p.gramasi * p.harga_kg) / 10000000) * 500 AS DECIMAL(18,2)) AS modal_rim_asli,
        -- Kalkulasi Harga Jual Rim
        CAST(CEIL(((CEIL((((p.panjang * p.lebar * p.gramasi * p.harga_kg) / 10000000) * 500) / 100) * 100) * v_multiplier_rim) / 500) * 500 AS DECIMAL(18,0)) AS jual_rim_final,
        -- Kalkulasi Harga Jual Eceran
        CAST(CEIL(((CEIL(((p.panjang * p.lebar * p.gramasi * p.harga_kg) / 10000000) / 25) * 25) * v_multiplier_eceran) / 100) * 100 AS DECIMAL(18,0)) AS jual_eceran_final
    FROM produk p 
    INNER JOIN kategori k ON k.kategori_id = p.kategori_id AND k.is_active = 1
    WHERE p.is_active = 1
    ORDER BY p.merk ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_produk_terlaris` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_produk_terlaris`(
    IN p_tanggal_mulai DATETIME,
    IN p_tanggal_selesai DATETIME
)
BEGIN
    SELECT 
        p.kode_barang, 
        p.nama_barang, 
        -- Menggunakan SUM dari nilai absolut qty mutasi keluar
        SUM(ABS(m.qty)) AS total_keluar_lembar, 
        p.stok_total AS sisa_stok 
    FROM stok_mutasi m 
    JOIN produk p ON m.produk_id = p.produk_id 
    WHERE m.jenis = 'KELUAR' 
      AND m.tanggal BETWEEN p_tanggal_mulai AND p_tanggal_selesai 
    GROUP BY p.produk_id, p.kode_barang, p.nama_barang, p.stok_total
    ORDER BY total_keluar_lembar DESC 
    LIMIT 10; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_produk_with_saldo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_produk_with_saldo`()
BEGIN
    SELECT 
        p.produk_id, 
        p.kode_barang, 
        p.nama_barang, 
        p.merk, 
        p.kategori, 
        p.gramasi, 
        p.panjang, 
        p.lebar, 
        p.harga_kg, 
        p.stok_minimal, 
        p.stok_total AS saldo_sisa 
    FROM produk p 
    WHERE p.is_active = 1 
    ORDER BY p.nama_barang ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_transaksi_keluar_detail_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_transaksi_keluar_detail_by_id`(
    IN p_keluar_id CHAR(36)
)
BEGIN
    SELECT 
        d.detail_keluar_id,
        prd.nama_barang,
        d.jumlah_jual,
        d.harga_jual_satuan,
        (d.jumlah_jual * d.harga_jual_satuan) AS subtotal_barang,
        -- Mengambil rincian biaya tambahan dalam format JSON agar Flutter mudah parsing
        IFNULL((
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'label', tam.label,
                    'amount', tam.amount,
                    'is_potong', tam.is_potong,
                    'ukuran', tam.ukuran_potong,
                    'jumlah', tam.jumlah_potong
                )
            )
            FROM stok_keluar_detail_tambahan tam
            WHERE tam.detail_keluar_id = d.detail_keluar_id
        ), '[]') AS list_biaya_tambahan,
        -- Total Biaya Tambahan per baris
        IFNULL((SELECT SUM(amount) FROM stok_keluar_detail_tambahan WHERE detail_keluar_id = d.detail_keluar_id), 0) AS total_biaya_tambahan
    FROM stok_keluar_detail d
    JOIN produk prd ON d.produk_id = prd.produk_id
    WHERE d.keluar_id = p_keluar_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_transaksi_keluar_header_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_transaksi_keluar_header_list`(
    IN p_tanggal_mulai DATETIME,
    IN p_tanggal_selesai DATETIME
)
BEGIN
    SELECT 
        h.keluar_id,
        h.no_nota,
        h.tanggal_keluar,
        p.nama_pelanggan,
        h.status_bayar,
        h.total_omzet,
        -- Menghitung ada berapa baris barang di nota ini
        (SELECT COUNT(*) 
         FROM stok_keluar_detail d 
         WHERE d.keluar_id = h.keluar_id) AS jumlah_item,
        h.create_by
    FROM stok_keluar_header h
    LEFT JOIN pelanggan p ON h.pelanggan_id = p.pelanggan_id
    WHERE h.tanggal_keluar BETWEEN p_tanggal_mulai AND p_tanggal_selesai
    ORDER BY h.tanggal_keluar DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_transaksi_keluar_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_transaksi_keluar_list`(
    IN p_tanggal_mulai DATETIME,
    IN p_tanggal_selesai DATETIME
)
BEGIN
    SELECT 
        h.no_nota,
        h.tanggal_keluar,
        plg.nama_pelanggan,
        prd.nama_barang,
        det.jumlah_jual,
        det.harga_jual_satuan,
        -- Total Dasar (Qty x Harga)
        (det.jumlah_jual * det.harga_jual_satuan) AS subtotal_barang,
        -- Total Biaya Tambahan per item (Potong, dll)
        IFNULL(SUM(tam.amount), 0) AS total_biaya_tambahan,
        -- Total Akhir per Baris
        (det.jumlah_jual * det.harga_jual_satuan) + IFNULL(SUM(tam.amount), 0) AS total_akhir_item,
        h.status_bayar
    FROM stok_keluar_header h
    JOIN pelanggan plg ON h.pelanggan_id = plg.pelanggan_id
    JOIN stok_keluar_detail det ON h.keluar_id = det.keluar_id
    JOIN produk prd ON det.produk_id = prd.produk_id
    LEFT JOIN stok_keluar_detail_tambahan tam ON det.detail_keluar_id = tam.detail_keluar_id
    WHERE h.tanggal_keluar BETWEEN p_tanggal_mulai AND p_tanggal_selesai
    GROUP BY det.detail_keluar_id, h.no_nota, h.tanggal_keluar, plg.nama_pelanggan, prd.nama_barang, det.jumlah_jual, det.harga_jual_satuan, h.status_bayar
    ORDER BY h.tanggal_keluar DESC, h.no_nota DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pembayaran_piutang` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pembayaran_piutang`(
    IN p_keluar_id CHAR(36),      -- ID Transaksi Penjualan
    IN p_jumlah_bayar DECIMAL(18,2),
    IN p_metode_bayar VARCHAR(50), -- Contoh: 'Tunai', 'Transfer BCA'
    IN p_keterangan VARCHAR(200),
    IN p_user_login VARCHAR(50)
)
BEGIN
    DECLARE v_pelanggan_id CHAR(36);
    DECLARE v_sisa_tagihan_header DECIMAL(18,2);

    -- 1. Ambil data pelanggan dan cek sisa hutang di nota ini
    SELECT pelanggan_id, sisa_piutang 
    INTO v_pelanggan_id, v_sisa_tagihan_header
    FROM stok_keluar_header 
    WHERE keluar_id = p_keluar_id;

    -- 2. Validasi Keamanan
    IF v_pelanggan_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Transaksi penjualan tidak ditemukan.';
    END IF;

    IF p_jumlah_bayar > v_sisa_tagihan_header THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Jumlah bayar melebihi sisa piutang nota ini.';
    END IF;

    -- 3. Catat Riwayat Pembayaran (Ke tabel yang kamu buat tadi)
    INSERT INTO stok_keluar_pembayaran (
        pembayaran_id, 
        keluar_id, 
        tanggal_bayar, 
        jumlah_bayar, 
        metode_bayar, 
        keterangan, 
        create_by
    ) VALUES (
        UUID(), 
        p_keluar_id, 
        NOW(), 
        p_jumlah_bayar, 
        p_metode_bayar, 
        p_keterangan, 
        p_user_login
    );

    -- 4. Potong Piutang di Nota Penjualan
    UPDATE stok_keluar_header 
    SET sisa_piutang = sisa_piutang - p_jumlah_bayar
    WHERE keluar_id = p_keluar_id;

    -- 5. Potong Total Piutang di Master Pelanggan & Naikkan Version
    UPDATE pelanggan 
    SET sisa_piutang = sisa_piutang - p_jumlah_bayar,
        version = version + 1
    WHERE pelanggan_id = v_pelanggan_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_report_sisa_hutang_supplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_report_sisa_hutang_supplier`()
BEGIN
    SELECT 
        s.supplier_id, 
        s.nama_supplier, 
        s.kontak_person, 
        s.termin_pembayaran,
        -- Menghitung total hutang dari semua nota masuk yang belum lunas
        IFNULL(SUM(m.sisa_hutang), 0) AS total_hutang,
        -- Mencari tanggal jatuh tempo paling dekat untuk prioritas bayar
        MIN(m.tanggal_jatuh_tempo) AS jatuh_tempo_terdekat 
    FROM supplier s 
    LEFT JOIN stok_masuk_header m ON s.supplier_id = m.supplier_id 
    WHERE s.is_active = 1 
    GROUP BY 
        s.supplier_id, 
        s.nama_supplier, 
        s.kontak_person, 
        s.termin_pembayaran
    HAVING total_hutang > 0 -- Menampilkan hanya supplier yang masih ada hutangnya
    ORDER BY jatuh_tempo_terdekat ASC; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_report_sisa_piutang_pelanggan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_report_sisa_piutang_pelanggan`()
BEGIN
    SELECT 
        p.pelanggan_id, 
        p.nama_pelanggan, 
        p.no_telp, 
        p.limit_kredit,
        -- Total omzet penjualan per pelanggan
        IFNULL(SUM(h.total_omzet), 0) AS total_omzet, 
        -- Saldo piutang yang tercatat di master pelanggan
        p.sisa_piutang AS saldo_berjalan 
    FROM pelanggan p 
    LEFT JOIN stok_keluar_header h ON p.pelanggan_id = h.pelanggan_id 
    WHERE p.is_active = 1 
    GROUP BY 
        p.pelanggan_id, 
        p.nama_pelanggan, 
        p.no_telp, 
        p.limit_kredit,
        p.sisa_piutang
    ORDER BY p.nama_pelanggan ASC; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_transaksi_stok_keluar_fifo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_transaksi_stok_keluar_fifo`(
    IN p_detail_keluar_id CHAR(36),
    IN p_keluar_id CHAR(36),
    IN p_produk_id CHAR(36),
    IN p_qty_jual INT,
    IN p_harga_jual DECIMAL(18,2),
    IN p_tanggal_transaksi DATETIME, 
    IN p_user_login VARCHAR(50),
    IN p_version_produk INT
)
BEGIN
    DECLARE v_qty_needed INT DEFAULT p_qty_jual;
    DECLARE v_saldo_lama INT;
    DECLARE v_batch_id CHAR(36);
    DECLARE v_batch_qty INT;
    DECLARE v_take INT;
    DECLARE v_subtotal DECIMAL(18,2);
    DECLARE v_pelanggan_id CHAR(36);
    
    SET v_subtotal = p_qty_jual * p_harga_jual;

    -- A. AMBIL DATA PELANGGAN
    SELECT pelanggan_id INTO v_pelanggan_id FROM stok_keluar_header WHERE keluar_id = p_keluar_id;

    -- 1. VALIDASI STOK & VERSION PRODUK (LOCK MASTER)
    SELECT IFNULL(stok_total, 0) INTO v_saldo_lama 
    FROM produk 
    WHERE produk_id = p_produk_id AND version = p_version_produk FOR UPDATE;

    IF v_saldo_lama IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produk tidak ditemukan atau version mismatch.';
    ELSEIF v_saldo_lama < p_qty_jual THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stok tidak mencukupi.';
    END IF;

    -- 2. PROSES FIFO (Looping per Batch)
    WHILE v_qty_needed > 0 DO
        SELECT d.detail_masuk_id, d.sisa_stok_batch 
        INTO v_batch_id, v_batch_qty
        FROM stok_masuk_detail d
        JOIN stok_masuk_header h ON d.masuk_id = h.masuk_id
        WHERE d.produk_id = p_produk_id AND d.sisa_stok_batch > 0
        ORDER BY h.tanggal_masuk ASC, d.detail_masuk_id ASC
        LIMIT 1 FOR UPDATE;

        IF v_batch_id IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Inkonsistensi data: Stok master ada, tapi sisa batch detail kosong.';
        END IF;

        IF v_batch_qty >= v_qty_needed THEN
            SET v_take = v_qty_needed;
            SET v_qty_needed = 0;
        ELSE
            SET v_take = v_batch_qty;
            SET v_qty_needed = v_qty_needed - v_take;
        END IF;

        -- Kurangi sisa di batch masuk
        UPDATE stok_masuk_detail SET sisa_stok_batch = sisa_stok_batch - v_take WHERE detail_masuk_id = v_batch_id;

        -- Simpan ke detail keluar
        INSERT INTO stok_keluar_detail (
            detail_keluar_id, keluar_id, produk_id, detail_masuk_id, jumlah_jual, harga_jual_satuan
        ) VALUES (
            IF(v_qty_needed + v_take = p_qty_jual, p_detail_keluar_id, UUID()), 
            p_keluar_id, p_produk_id, v_batch_id, v_take, p_harga_jual
        );
    END WHILE;

    -- 3. UPDATE MASTER PRODUK
    UPDATE produk 
    SET stok_total = stok_total - p_qty_jual, 
        version = version + 1,
        update_date = NOW(),
        update_by = p_user_login
    WHERE produk_id = p_produk_id AND version = p_version_produk;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Optimistic concurrency error: Data produk sudah berubah.';
    END IF;

    -- 4. UPDATE PIUTANG PELANGGAN
    UPDATE pelanggan 
    SET sisa_piutang = sisa_piutang + v_subtotal,
        version = version + 1
    WHERE pelanggan_id = v_pelanggan_id;

    -- 5. CATAT MUTASI (Gunakan nama kolom: tanggal_transaksi)
    INSERT INTO stok_mutasi (
        mutasi_id, 
        tanggal, -- Sesuai script ALTER kita
        produk_id, 
        jenis, 
        ref_id, 
        qty, 
        saldo, 
        keterangan,
        create_date,
        create_by
    ) VALUES (
        UUID(), 
        IFNULL(p_tanggal_transaksi, NOW()), 
        p_produk_id, 
        'KELUAR', 
        p_keluar_id, 
        -p_qty_jual, 
        (v_saldo_lama - p_qty_jual), 
        CONCAT('Penjualan - No Nota: ', p_keluar_id),
        NOW(),
        p_user_login
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_transaksi_stok_masuk` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_transaksi_stok_masuk`(
    IN p_masuk_id CHAR(36),
    IN p_produk_id CHAR(36),
    IN p_jumlah_masuk INT,
    IN p_satuan VARCHAR(50),
    IN p_harga_beli DECIMAL(18,2),
    IN p_tanggal_transaksi DATETIME,
    IN p_create_by VARCHAR(50)
)
BEGIN
    DECLARE v_saldo_lama INT;
    DECLARE v_new_detail_id CHAR(36);

    -- 1. LOCK baris produk
    SELECT IFNULL(stok_total, 0) INTO v_saldo_lama 
    FROM produk 
    WHERE produk_id = p_produk_id FOR UPDATE;

    IF v_saldo_lama IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produk tidak ditemukan.';
    END IF;

    SET v_new_detail_id = UUID();

    -- 2. Insert detail masuk
    INSERT INTO stok_masuk_detail (
        detail_masuk_id, masuk_id, produk_id, jumlah_masuk, 
        satuan_digunakan, harga_beli_satuan, sisa_stok_batch
    ) VALUES (
        v_new_detail_id, p_masuk_id, p_produk_id, p_jumlah_masuk, 
        p_satuan, p_harga_beli, p_jumlah_masuk
    );

    -- 3. Update master stok
    UPDATE produk 
    SET stok_total = v_saldo_lama + p_jumlah_masuk,
        version = version + 1,
        update_date = NOW(),
        update_by = p_create_by
    WHERE produk_id = p_produk_id;

    -- 4. Insert mutasi (Gunakan nama kolom hasil ALTER: tanggal_transaksi)
    INSERT INTO stok_mutasi (
        mutasi_id, 
        tanggal, -- Sesuai script ALTER kita
        produk_id, 
        jenis, 
        ref_id, 
        qty, 
        saldo,             -- Ini adalah saldo snapshot setelah transaksi ini
        keterangan,
        create_date,
        create_by
    ) VALUES (
        UUID(), 
        IFNULL(p_tanggal_transaksi, NOW()), 
        p_produk_id, 
        'MASUK', 
        p_masuk_id, 
        p_jumlah_masuk, 
        (v_saldo_lama + p_jumlah_masuk), 
        CONCAT('Penerimaan Barang - Ref: ', p_masuk_id),
        NOW(),
        p_create_by
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-26 22:51:40
