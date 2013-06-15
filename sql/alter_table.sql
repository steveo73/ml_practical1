ALTER TABLE train_data_hack ADD totl_family INT AFTER parch;
ALTER TABLE train_data_hack ADD fare_individual DOUBLE AFTER fare;
ALTER TABLE train_data_hack ADD age_banding INT AFTER age;

