<!-- display company format image -->
# DB schematics:

### Companies table:

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

### Users table:
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