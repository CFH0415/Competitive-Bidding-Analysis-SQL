USE construction_bid_analysis;

DROP TABLE IF EXISTS bids_raw_v2;

CREATE TABLE bids_raw_v2 (
    `Index` VARCHAR(50),
    `date` VARCHAR(50),
    `time` VARCHAR(50),
    `location` VARCHAR(255),
    `project` TEXT,
    `note` TEXT,
    `Latitude` VARCHAR(50),
    `Longitude` VARCHAR(50),
    `prevailing_wages` VARCHAR(50),
    `price_of_diesel` VARCHAR(50),
    `mix_tn` VARCHAR(50),
    `grade_cy` VARCHAR(50),
    `base_tn` VARCHAR(50),
    `shldr_tn` VARCHAR(50),
    `mill_sy` VARCHAR(50),
    `crush_tn` VARCHAR(50),
    `stock_tn` VARCHAR(50),
    `box` VARCHAR(50),

    `bidder_1_name` VARCHAR(255),
    `bidder_1_total` VARCHAR(50),
    `bidder_2_name` VARCHAR(255),
    `bidder_2_total` VARCHAR(50),

    `bidder_3_name` VARCHAR(255),
    `bidder_3_total` VARCHAR(50),
    `bidder_4_name` VARCHAR(255),
    `bidder_4_total` VARCHAR(50),
    `bidder_5_name` VARCHAR(255),
    `bidder_5_total` VARCHAR(50),
    `bidder_6_name` VARCHAR(255),
    `bidder_6_total` VARCHAR(50),
    `bidder_7_name` VARCHAR(255),
    `bidder_7_total` VARCHAR(50),
    `bidder_8_name` VARCHAR(255),
    `bidder_8_total` VARCHAR(50),
    `bidder_9_name` VARCHAR(255),
    `bidder_9_total` VARCHAR(50),
    `bidder_10_name` VARCHAR(255),
    `bidder_10_total` VARCHAR(50),
    `bidder_11_name` VARCHAR(255),
    `bidder_11_total` VARCHAR(50),
    `bidder_12_name` VARCHAR(255),
    `bidder_12_total` VARCHAR(50),
    `bidder_13_name` VARCHAR(255),
    `bidder_13_total` VARCHAR(50),
    `bidder_14_name` VARCHAR(255),
    `bidder_14_total` VARCHAR(50),
    `bidder_15_name` VARCHAR(255),
    `bidder_15_total` VARCHAR(50),

    `engineer_estimate` VARCHAR(50),
    `target_company_win` VARCHAR(50),
    `target_company_bid` VARCHAR(50),
    `bid_difference` VARCHAR(50),
    `underbid_flag` VARCHAR(50),
    `missed_out_flag` VARCHAR(50),
    `state_clean` VARCHAR(50),
    `region_full` VARCHAR(50),
    `project_type` VARCHAR(255)
);

LOAD DATA INFILE '/private/tmp/bid_data_with_project_type.csv'
INTO TABLE bids_raw_v2
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Check raw row count
SELECT COUNT(*) AS total_raw_rows
FROM bids_raw_v2;

-- Check project type distribution
SELECT 
    TRIM(project_type) AS project_type,
    COUNT(*) AS bid_count
FROM bids_raw_v2
GROUP BY TRIM(project_type)
ORDER BY bid_count DESC;