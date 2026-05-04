DROP PROCEDURE IF EXISTS `sp_get_produk_price_list`;
DELIMITER ;;
CREATE PROCEDURE `sp_get_produk_price_list`(
    IN p_untung_rim_percent DECIMAL(5,2),
    IN p_untung_eceran_percent DECIMAL(5,2)
)
BEGIN
    DECLARE v_multiplier_rim DECIMAL(10,4);
    DECLARE v_multiplier_eceran DECIMAL(10,4);
    
    -- Set multiplier (Default ke 1.00 jika parameter null)
    SET v_multiplier_rim = 1 + (IFNULL(p_untung_rim_percent, 1.00) / 100);
    SET v_multiplier_eceran = 1 + (IFNULL(p_untung_eceran_percent, 1.00) / 100);

    -- Query Utama dengan pengurutan berdasarkan Nama Kategori
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
        p.version, 
        p.create_date, 
        p.create_by, 
        p.update_date, 
        p.update_by,
        -- Subquery untuk list konversi JSON
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
    ORDER BY k.nama_kategori ASC; 
END ;;
DELIMITER ;