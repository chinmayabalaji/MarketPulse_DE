COPY bronze.us_stocks_data_raw
FROM 's3://dev-marketpulse-stock-data/'
IAM_ROLE 'arn:aws:iam::317135987005:role/stock_lambda_role'
FORMAT JSON 'auto';