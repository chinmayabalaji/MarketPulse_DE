CREATE SCHEMA IF NOT EXISTS bronze;

CREATE SCHEMA IF NOT EXISTS silver;

CREATE SCHEMA IF NOT EXISTS gold;

CREATE TABLE IF NOT EXISTS bronze.us_stocks_data (
    source_filename varchar(100) not null,
    row_number int not null,
    json_data super not null,
    ingested_at timestamp default GETDATE()
)

CREATE TABLE IF NOT EXISTS silver.us_stocks_data_hist (
    ticker_symbol varchar(20) not null,
    volumn float not null,
    volume_weight_avg_price float not null,
    open_price float not null,
    close_price float not null,
    high_price float not null,
    low_price float not null,
    time_stamp timestamp not null,
    no_of_transactions float not null,
    source_filename varchar(100) not null,
    row_number int not null,
    row_effective_start_date timestamp not null,
    row_effective_end_date timestamp not null,
    active_flag varchar(1) not null
)

CREATE TABLE IF NOT EXISTS gold.us_stocks_data (
    ticker_symbol varchar(20) not null,
    volumn float not null,
    volume_weight_avg_price float not null,
    open_price float not null,
    close_price float not null,
    high_price float not null,
    low_price float not null,
    time_stamp timestamp not null,
    no_of_transactions float not null,
    source_filename varchar(100) not null,
    row_number int not null,
    row_effective_start_date timestamp not null,
    row_effective_end_date timestamp not null
)