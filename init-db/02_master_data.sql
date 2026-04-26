-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: inventory
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
-- Dumping data for table `kategori`
--

/*!40000 ALTER TABLE `kategori` DISABLE KEYS */;
INSERT INTO `kategori` VALUES (1,'HVS / Woodfree','HVS',1),(2,'Art Paper','AP',1),(3,'Art Carton','AC',1),(4,'Ivory / Food Grade','IV',1),(5,'Brief Card / Manila','BC',1),(6,'Buffalo / Linen','BFL',1),(7,'Duplex / Coated Board','DP',1),(8,'Sticker Bontax / Vinyl','STK',1),(9,'Kalkir / Tracing Paper','KLK',1),(10,'NCR (Carbonless)','NCR',1),(11,'Samson / Kraft','KFT',1),(12,'Corrugated Board','CRG',1);
/*!40000 ALTER TABLE `kategori` ENABLE KEYS */;

--
-- Dumping data for table `satuan`
--

/*!40000 ALTER TABLE `satuan` DISABLE KEYS */;
INSERT INTO `satuan` VALUES (1,'Lembar','LBR',1,1,'2026-04-16 22:24:33',NULL),(2,'Pack','PCK',2,1,'2026-04-16 22:24:33',NULL),(3,'Rim','RIM',3,1,'2026-04-16 22:24:33',NULL),(4,'Box','BOX',4,1,'2026-04-16 22:24:33',NULL);
/*!40000 ALTER TABLE `satuan` ENABLE KEYS */;

--
-- Dumping data for table `sys_config`
--

/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES ('HARDWARE_ID','Fyckeww52ux4dryLaOr2z9jMXTYN/kp0hfRB5D3LArI=','Registered Server Serial Number','2026-04-23 22:36:15'),('LICENSE_KEY','wNKp/0HawgIG5rZcLhqmsg==','Encrypted Application Expiry Date','2026-04-25 00:14:09');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;

--
-- Dumping data for table `sys_permission`
--

/*!40000 ALTER TABLE `sys_permission` DISABLE KEYS */;
INSERT INTO `sys_permission` VALUES ('CUST_CREATE','Tambah Customer','MASTER'),('CUST_DELETE','Hapus Customer','MASTER'),('CUST_READ','Lihat Customer','MASTER'),('CUST_UPDATE','Edit Customer','MASTER'),('INV_ADD','Tambah Barang Baru','INVENTORY'),('INV_DELETE','Hapus Barang','INVENTORY'),('INV_EDIT','Edit Data Barang','INVENTORY'),('INV_VIEW','Lihat Stok Barang','INVENTORY'),('PAY_CREATE','Input Pembayaran/Cicilan','TRANSACTION'),('PAY_DELETE','Batal Transaksi Pembayaran','TRANSACTION'),('PAY_READ','Lihat Riwayat Pembayaran','TRANSACTION'),('PROD_CREATE','Tambah Produk','INVENTORY'),('PROD_DELETE','Hapus Produk','INVENTORY'),('PROD_READ','Lihat Produk','INVENTORY'),('PROD_UPDATE','Edit Produk','INVENTORY'),('RPT_MUTASI','Cetak Laporan Mutasi Stok','REPORT'),('RPT_PIUTANG','Cetak Laporan Piutang','REPORT'),('RPT_SALES','Cetak Laporan Penjualan','REPORT'),('RPT_STOK','Cetak Laporan Stok','REPORT'),('SALE_PRINT','Cetak Nota & Surat Jalan','TRANSACTION'),('SALE_VIEW','Lihat Daftar Nota Penjualan','TRANSACTION'),('SALE_VOID','Void/Batalkan Nota Penjualan','TRANSACTION'),('STOK_IN','Input Stok Masuk','TRANSACTION'),('STOK_OUT','Input Stok Keluar','TRANSACTION'),('SUPP_CREATE','Tambah Supplier','MASTER'),('SUPP_DELETE','Hapus Supplier','MASTER'),('SUPP_READ','Lihat Supplier','MASTER'),('SUPP_UPDATE','Edit Supplier','MASTER'),('USR_CREATE','Tambah User Baru','SECURITY'),('USR_DELETE','Hapus User','SECURITY'),('USR_UPDATE','Edit Data & Role User','SECURITY'),('USR_VIEW','Lihat Daftar User','SECURITY');
/*!40000 ALTER TABLE `sys_permission` ENABLE KEYS */;

--
-- Dumping data for table `sys_role`
--

/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES ('ADM','Administrator'),('GUD','Staff Gudang'),('OWN','Owner'),('SPV','Supervisor Inventory');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;

--
-- Dumping data for table `sys_role_permission`
--

/*!40000 ALTER TABLE `sys_role_permission` DISABLE KEYS */;
INSERT INTO `sys_role_permission` VALUES ('SPV','CUST_CREATE'),('SPV','CUST_DELETE'),('SPV','CUST_READ'),('SPV','CUST_UPDATE'),('ADM','INV_ADD'),('GUD','INV_ADD'),('SPV','INV_ADD'),('ADM','INV_DELETE'),('SPV','INV_DELETE'),('ADM','INV_EDIT'),('GUD','INV_EDIT'),('SPV','INV_EDIT'),('ADM','INV_VIEW'),('GUD','INV_VIEW'),('SPV','INV_VIEW'),('SPV','PROD_CREATE'),('SPV','PROD_DELETE'),('SPV','PROD_READ'),('SPV','PROD_UPDATE'),('ADM','RPT_STOK'),('SPV','RPT_STOK'),('SPV','STOK_IN'),('SPV','STOK_OUT'),('SPV','SUPP_CREATE'),('SPV','SUPP_DELETE'),('SPV','SUPP_READ'),('SPV','SUPP_UPDATE'),('ADM','USR_VIEW'),('SPV','USR_VIEW');
/*!40000 ALTER TABLE `sys_role_permission` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-25 14:27:54
