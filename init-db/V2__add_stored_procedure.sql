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
DROP PROCEDURE IF EXISTS `sp_eksekusi_stok_opname`;
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
DROP PROCEDURE IF EXISTS `sp_get_kartu_stok`;
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
            '-' AS no_nota,
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
            t.no_nota,
            t.ref_id,
            t.qty_masuk,
            t.qty_keluar,
            (v_saldo_awal + SUM(t.raw_qty) OVER (ORDER BY t.tanggal ASC, t.create_date ASC, t.raw_qty DESC)) AS saldo,
            t.keterangan,
            t.create_by,
            1 AS sort_priority -- Prioritas 1 untuk transaksi
        FROM (
            SELECT 
                sm.tanggal, sm.create_date, sm.jenis, 
				CASE 
                    WHEN sm.jenis = 'MASUK' THEN IFNULL(skd.no_po, '-')
                    WHEN sm.jenis = 'KELUAR' THEN IFNULL(skh.no_nota, '-')
                    ELSE '-' 
                END AS no_nota,
                sm.ref_id, sm.qty AS raw_qty,
                CASE WHEN sm.qty > 0 THEN sm.qty ELSE 0 END AS qty_masuk,
                CASE WHEN sm.qty < 0 THEN ABS(sm.qty) ELSE 0 END AS qty_keluar,
				CASE 
                    WHEN sm.jenis = 'MASUK' THEN CONCAT('Pembelian Barang. No. Nota: ', IFNULL(skd.no_po, '-'))
                    WHEN sm.jenis = 'KELUAR' THEN CONCAT('Penjualan Barang. No. Nota: ', IFNULL(skh.no_nota, '-'))
                    ELSE sm.keterangan
                END AS keterangan,
                s.full_name AS create_by
            FROM stok_mutasi sm
            LEFT JOIN stok_keluar_header skh ON skh.keluar_id = sm.ref_id
            LEFT JOIN stok_masuk_header skd ON skd.masuk_id = sm.ref_id
            INNER JOIN sys_user s ON s.user_id = sm.create_by
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
DROP PROCEDURE IF EXISTS `sp_get_produk_price_list`;
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
DROP PROCEDURE IF EXISTS `sp_get_produk_terlaris`;
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
DROP PROCEDURE IF EXISTS `sp_get_produk_with_saldo`;
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
DROP PROCEDURE IF EXISTS `sp_get_transaksi_keluar_detail_by_id`;
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
DROP PROCEDURE IF EXISTS `sp_get_transaksi_keluar_header_list`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_transaksi_keluar_header_list`(
    IN p_tanggal_mulai DATETIME,
    IN p_tanggal_selesai DATETIME
)
BEGIN
    SELECT 
        h.keluar_id,
        h.no_nota,
        h.no_surat_jalan,
        h.tanggal_keluar,
        p.nama_pelanggan,
        h.status_bayar,
        h.total_omzet,
        -- Menghitung ada berapa baris barang di nota ini
        (SELECT COUNT(*) 
         FROM stok_keluar_detail d 
         WHERE d.keluar_id = h.keluar_id) AS jumlah_item,
        u.full_name AS create_by
    FROM stok_keluar_header h
    LEFT JOIN pelanggan p ON h.pelanggan_id = p.pelanggan_id
    LEFT JOIN sys_user u ON u.user_id = h.create_by
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
DROP PROCEDURE IF EXISTS `sp_get_transaksi_keluar_list`;
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
DROP PROCEDURE IF EXISTS `sp_pembayaran_piutang`;
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
DROP PROCEDURE IF EXISTS `sp_report_sisa_hutang_supplier`;
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
DROP PROCEDURE IF EXISTS `sp_report_sisa_piutang_pelanggan`;
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
DROP PROCEDURE IF EXISTS `sp_transaksi_stok_keluar_fifo`;
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
DROP PROCEDURE IF EXISTS `sp_transaksi_stok_masuk`;
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

-- Dump completed on 2026-05-04 20:29:15
