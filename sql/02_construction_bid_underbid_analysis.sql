USE construction_bid_analysis;

DROP TABLE IF EXISTS bids_clean;

CREATE TABLE bids_clean AS
SELECT
    CAST(NULLIF(`Index`, '') AS UNSIGNED) AS bid_id,
    DATE(LEFT(`date`, 10)) AS bid_date,

    TRIM(location) AS location,
    TRIM(project) AS project,

    CAST(NULLIF(Latitude, '') AS DECIMAL(10,6)) AS latitude,
    CAST(NULLIF(Longitude, '') AS DECIMAL(10,6)) AS longitude,
    CAST(NULLIF(prevailing_wages, '') AS UNSIGNED) AS prevailing_wages,
    CAST(NULLIF(price_of_diesel, '') AS DECIMAL(10,3)) AS price_of_diesel,

    CAST(NULLIF(NULLIF(engineer_estimate, ''), 'NA') AS DECIMAL(15,2)) AS engineer_estimate,

    NULLIF(NULLIF(TRIM(bidder_1_name), ''), 'NA') AS bidder_1_name,
    CAST(NULLIF(NULLIF(bidder_1_total, ''), 'NA') AS DECIMAL(15,2)) AS bidder_1_total,

    NULLIF(NULLIF(TRIM(bidder_2_name), ''), 'NA') AS bidder_2_name,
    CAST(NULLIF(NULLIF(bidder_2_total, ''), 'NA') AS DECIMAL(15,2)) AS bidder_2_total,

    CAST(NULLIF(target_company_win, '') AS UNSIGNED) AS target_company_win,
    CAST(NULLIF(target_company_bid, '') AS DECIMAL(15,2)) AS target_company_bid,
    CAST(NULLIF(bid_difference, '') AS DECIMAL(10,4)) AS bid_difference,

    underbid_flag,
    missed_out_flag,

    TRIM(state_clean) AS state_clean,
    TRIM(region_full) AS region_full,
    TRIM(project_type) AS project_type

FROM bids_raw_v2;

-- Check cleaned row count
SELECT COUNT(*) AS total_rows
FROM bids_clean;

-- Analysis 1: Project type contribution to total underbidding loss
SELECT
    project_type,
    COUNT(*) AS total_won_bids,
    SUM(CASE WHEN underbid_flag = 'Bomb' THEN 1 ELSE 0 END) AS underbid_count,

    ROUND(
        SUM(CASE 
            WHEN underbid_flag = 'Bomb'
            THEN bidder_2_total - target_company_bid
            ELSE 0
        END), 2
    ) AS total_underbid_loss,

    ROUND(
        SUM(CASE 
            WHEN underbid_flag = 'Bomb'
            THEN bidder_2_total - target_company_bid
            ELSE 0
        END)
        /
        SUM(SUM(CASE 
            WHEN underbid_flag = 'Bomb'
            THEN bidder_2_total - target_company_bid
            ELSE 0
        END)) OVER(),
        2
    ) AS loss_share_pct,

    ROUND(
        SUM(CASE WHEN underbid_flag = 'Bomb' THEN 1 ELSE 0 END)
        /
        SUM(SUM(CASE WHEN underbid_flag = 'Bomb' THEN 1 ELSE 0 END)) OVER(),
        2
    ) AS underbid_count_share_pct

FROM bids_clean
WHERE target_company_win = 1
GROUP BY project_type
ORDER BY loss_share_pct DESC;

-- Analysis 2: Frequency vs. severity decomposition
-- Total Underbidding Loss = Underbid Count × Average Loss per Underbid Case

SELECT
    project_type,
    COUNT(*) AS total_won_bids,
    SUM(CASE WHEN underbid_flag = 'Bomb' THEN 1 ELSE 0 END) AS underbid_count,

    ROUND(
        SUM(CASE 
            WHEN underbid_flag = 'Bomb'
            THEN bidder_2_total - target_company_bid
            ELSE 0
        END), 2
    ) AS total_underbid_loss,

    ROUND(
        SUM(CASE 
            WHEN underbid_flag = 'Bomb'
            THEN bidder_2_total - target_company_bid
            ELSE 0
        END)
        / NULLIF(SUM(CASE WHEN underbid_flag = 'Bomb' THEN 1 ELSE 0 END), 0),
        2
    ) AS avg_loss_per_underbid_case,

    ROUND(
        SUM(CASE WHEN underbid_flag = 'Bomb' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS underbid_rate

FROM bids_clean
WHERE target_company_win = 1
GROUP BY project_type
ORDER BY total_underbid_loss DESC;