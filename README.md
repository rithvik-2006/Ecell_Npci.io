# Universal Rewards System

## Overview

The Universal Rewards System is a comprehensive platform designed to streamline and enhance the management and distribution of rewards. This system aims to provide a seamless experience for both sellers and customers by integrating various reward mechanisms into a single, unified interface. By leveraging advanced technology, the Universal Rewards System offers a scalable and efficient solution to boost customer engagement and loyalty.

## Screenshots

We offer two distinct login options: one for customers and one for sellers. Below, we demonstrate logging in using a customer email, which grants access to the dashboard.

<img src="https://i.ibb.co/qLWgc2FR/Screenshot-20250205-040208.png" alt="Customer Login Screenshot" width="200px" border="0">

Users can also create a new account by signing up.

<img src="https://i.ibb.co/MkhXg3hR/Screenshot-20250205-040156.png" alt="Signup Screenshot" width="200px" border="0">

After logging in as a customer, users are redirected to the home page where they can view their total points in URT and recent transactions. The home page provides a clear overview of the rewards status, including the ability to:

- **Transfer Points**: Convert your points to URT points, which can be used across various platforms and services.
- **Redeem Points**: Convert your URT points back to points for use within specific reward programs.

<img src="https://i.ibb.co/7t965PJ7/Screenshot-20250205-040340.png" alt="Home Page Screenshot" width="200px" border="0">

<img src="https://i.ibb.co/csn0CQZ/Screenshot-20250205-040426.jpg" alt="Points Overview Screenshot" width="200px" border="0">

At the top, users can see their points in URT and the equivalent in different businesses such as Amazon points or Flipkart points. Points can be redeemed across various businesses.

<img src="https://i.ibb.co/BHrT2sjM/Screenshot-20250205-040936.png" alt="Points Conversion Screenshot" width="200px" border="0">

The Smart Conversion section allows users to convert points dynamically.

<img src="https://i.ibb.co/F4L2rMqm/Screenshot-20250205-040851.png" alt="Smart Conversion Screenshot" width="200px" border="0">

The transfer page enables users to import points from businesses into the Universal Rewards System.

<img src="https://i.ibb.co/NdR29T8X/Screenshot-20250205-041006.jpg" alt="Transfer Page Screenshot" width="200px" border="0">

<img src="https://i.ibb.co/qqNFZZg/Screenshot-20250205-041117.png" alt="Import Points Screenshot" width="200px" border="0">

Sellers can also log in and access their seller dashboard.

<img src="https://i.ibb.co/Wpy46z03/Screenshot-20250205-041751.png" alt="Seller Dashboard Screenshot" width="200px" border="0">

## Installation

Instructions on how to install and run the project.

1. To install the APK, click the following link:

[Download APK](https://github.com/rithvik-2006/Ecell_Npci.io/releases/download/v1.0/app-release.apk)

2. To host the backend server, simply use ``ts-node`` to run the Express App. You need to edit the .env file according to .env.example.

3. We also need an SQL server with tables created according to the following database schematics:

4. Also note that backend URL is set in [api_service.dart](https://github.com/rithvik-2006/Ecell_Npci.io/blob/0e68fec3b27fd7ac7ddf8679f59656fb82c878c4/frontend/lib/services/api_service.dart#L10). You may need to modify this and run ``flutter build apk``

# DB schematics

### Companies table

| Field              | Type          | Null | Key | Default           | Extra                                         |
|--------------------|---------------|------|-----|-------------------|-----------------------------------------------|
| company_id         | int           | NO   | PRI | NULL              | auto_increment                                |
| points_earned      | decimal(10,2) | YES  |     | 0.00              |                                               |
| monthly_sales      | decimal(15,2) | YES  |     | NULL              |                                               |
| reward_token_value | decimal(10,2) | YES  |     | NULL              |                                               |
| scaling_constant   | decimal(10,2) | YES  |     | NULL              |                                               |
| created_at         | timestamp     | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED                             |
| updated_at         | timestamp     | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| image_path         | varchar(255)  | YES  |     | NULL              |                                               |
| company_type       | varchar(255)  | YES  |     | NULL              |                                               |
| name               | varchar(255)  | NO   |     | NULL              |                                               |

### Users table

| Field                 | Type          | Null | Key | Default           | Extra                                         |
|-----------------------|---------------|------|-----|-------------------|-----------------------------------------------|
| uid                   | char(36)      | NO   | PRI | uuid()            | DEFAULT_GENERATED                             |
| points                | decimal(10,2) | YES  |     | 0.00              |                                               |
| last_transaction_date | datetime      | YES  |     | NULL              |                                               |
| last_20_transactions  | json          | YES  |     | NULL              |                                               |
| created_at            | timestamp     | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED                             |
| updated_at            | timestamp     | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| email                 | varchar(255)  | NO   | UNI | NULL              |                                               |
| display_name          | varchar(255)  | NO   |     | NULL              |                                               |

## Points table

| Column Name  | Data Type      | Nullable | Key Type   | Default | Extra Information          | Description |
|-------------|--------------|---------|-----------|---------|------------------------|-------------|
| company_id  | int         | NO      | PRIMARY KEY | NULL    | auto_increment          | Unique identifier for each company. |
| name        | varchar(255) | NO      | UNIQUE      | NULL    |                            | Name of the company (must be unique). |
| pool        | json        | NO      | None       | NULL    |                            | Stores JSON data related to the company. |
