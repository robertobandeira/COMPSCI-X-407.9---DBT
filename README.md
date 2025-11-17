# dbt + BigQuery Demo (Looker company Data)

This repository contains the dbt project we use in class to demonstrate how to build **ELT pipelines** on top of **BigQuery** using **dbt**.

By the end of this setup, you will be able to:

- Connect dbt to BigQuery using a **JSON service account key**
- Run dbt models that transform raw Looker company data into analytics-ready tables
- Run tests and generate documentation with dbt

> 💡 **Important:** Your dbt **profile** (credentials) is stored **outside** this repo, in a local `profiles.yml` file. This keeps secrets out of GitHub.
---
# 0. About this Dataset
The models in this project follow a modern analytics engineering approach to organizing transformation logic. After defining our raw tables as sources and creating lightweight staging models that clean and standardize those inputs, we build a curated mart layer designed for analysis and BI consumption. These marts consolidate core business entities (customers, products, orders, order items, distribution centers) into clearly defined dimensions and facts. This structure mirrors what you would find in a professional ecommerce analytics environment and ensures that downstream tools like Looker Studio can easily answer questions without repeatedly joining raw tables.

The mart layer is built using the Looker e-commerce dataset and includes both dimensional models (e.g., customers, products, distribution centers) and fact models at different grains (order-level, order-item-level, and daily aggregated facts). This enables a wide range of insights: from user acquisition and product performance to fulfillment behavior and operational trends. We also introduce daily event and sales aggregations, which serve as the backbone for a complete analytics dashboard—supporting KPIs, time-series visualizations, channel attribution, and funnel analysis. Together, these marts represent a clean, unified semantic layer that abstracts away complexity and provides students with a real-world example of how production-grade data modeling is organized.

---

# 1. Prerequisites

Make sure all of the following are true **before continuing**.

## 1.1. JSON service account key

You need a `.json` key file that allows dbt to connect to BigQuery. To connect dbt to BigQuery, you’ll need a JSON key for the service account used in this course. Follow these steps: In the Google Cloud Console, go to IAM & Admin → Service Accounts, select the service account Roberto provided (490_dbt_demo), then open the Keys tab. Click “Add Key → Create new key”, choose JSON, and download the file. Save it somewhere on your computer where it won’t be accidentally deleted, such as ~/keys/gcp-sa.json on macOS or C:\Users\<yourname>\keys\gcp-sa.json on Windows. You’ll reference this file in your profiles.yml under the keyfile: field. Never upload or commit this file to GitHub.

Example paths:

### Windows:
```
C:\Users\<yourname>\keys\gcp-sa.json
```

### macOS:
```
/Users/<yourname>/keys/gcp-sa.json
```

Make sure this file exists and you know the **full absolute path**.

---

## 1.2. Python + dbt

You need:

- **Python 3.10+**
- **dbt-bigquery**

You’ll install dbt inside a virtual environment in the steps below.

---

# 2. Clone this repository

Choose a folder where you keep your projects.

### Windows (PowerShell):
```powershell
cd C:\Users\<yourname>\Documents
git clone https://github.com/robertobandeira/COMPSCI-X-407.9---DBT dbt_demo
cd dbt_demo
```

### macOS / Linux:
```bash
cd ~/Documents
git clone https://github.com/robertobandeira/COMPSCI-X-407.9---DBT dbt_demo
cd dbt_demo
```


# 3. Set up Python environment and install dbt

## 3.1. Create & activate a virtual environment

### Windows (PowerShell):
```powershell
py -3 -m venv .venv
. .venv\Scripts\Activate.ps1
```

### macOS / Linux:
```bash
python3 -m venv .venv
source .venv/bin/activate
```

## 3.2. Install dbt-bigquery

```bash
pip install --upgrade pip
pip install dbt-bigquery
```

Check installation:

```bash
dbt --version
```

You should see:

- `Core: x.y.z`
- `Plugins: - bigquery: x.y.z`

---

# 4. Configure dbt credentials (`profiles.yml`)

dbt uses a file called **profiles.yml** to know how to connect to BigQuery.

This file does **not** live in your project.  
It lives in your global dbt folder.

---

## 4.1. Find your dbt profiles directory

Run:

```bash
dbt debug --config-dir
```

You will see one of these:

### Windows:
```
C:\Users\<yourname>\.dbt
```

### macOS:
```
/Users/<yourname>/.dbt
# or: ~/.dbt
```

---

## 4.2. Copy the template from the repo

This repo includes a file called:

```
profiles-template.yml
```

You must copy this into your dbt profiles directory and rename it to:

```
profiles.yml
```

### Windows (PowerShell):
```powershell
Copy-Item ".\profiles-template.yml" "C:\Users\<yourname>\.dbt\profiles.yml"
```

### macOS / Linux:
```bash
cp profiles-template.yml ~/.dbt/profiles.yml
```

---

## 4.3. Edit `profiles.yml`

Open the file you just copied and edit the following fields:

```yaml
dbt_demo:                  # MUST match the `profile:` name in dbt_project.yml
  target: dev
  outputs:
    dev:
      dataset: dbt_demo_dev              # e.g. feel free to use your own (existing) dataset
      job_execution_timeout_seconds: 300
      job_retries: 1
      keyfile: <FULL_PATH_TO_YOUR_JSON_KEY> # e.g. C:\Users\beto_\Downloads\compsci-x-407-9-87abce5b61f7.json
      location: US
      method: service-account
      priority: interactive
      project: compsci-x-407-9
      threads: 1
      type: bigquery
```

### Windows example:
```yaml
keyfile: C:\Users\alice\keys\gcp-sa.json
dataset: lieve_dataset
```

### macOS example:
```yaml
keyfile: /Users/alice/keys/gcp-sa.json
dataset: tori_dataset
```

---

# 5. Test your setup

From inside the repo folder:

```bash
dbt debug
```

If everything is working, you will see:

- `Project loading: OK`
- `Profiles configured: OK`
- `Connection test: OK`

If not:

- Check that `profiles.yml` is in the correct folder (from `--config-dir`)
- Check the JSON key path is correct
- Check the `project` and `dataset` values match what exists in BigQuery
- Check your service account permissions

---

# 6. Project structure

```
dbt_demo/
├── dbt_project.yml
├── profiles-template.yml
├── models/
│   ├── sources/
│   ├── staging/
│   └── marts/
└── README.md
```

- `sources/` contains references to raw BigQuery tables  
- `staging/` contains cleaned versions of source tables  
- `marts/` contains final analytics tables used for BI  

---

# 7. Running dbt

### Build all models:

```bash
dbt run
```

### Run tests:

```bash
dbt test
```

### Generate documentation:

```bash
dbt docs generate
dbt docs serve
```

Open the URL shown in your terminal to explore the lineage graph.

---

# 8. Viewing results in BigQuery

In the BigQuery web UI:

1. Choose your project (e.g. `compsci-x-407-9`)
2. Expand your dataset (e.g. `dbt_demo_dev`)
3. Look for:

```
stg__events
stg__orders
fct_order_items
fct_daily_sales
```

Run a quick query:

```sql
SELECT * 
FROM `compsci-x-407-9.dbt_demo_dev.daily_sales`
LIMIT 10;
```

---

# 9. Troubleshooting

### ❌ `profiles.yml not found`
You didn’t put it in the directory printed by:

```
dbt debug --config-dir
```

### ❌ Permission denied / 403
Your service account does not have:

- BigQuery Data Viewer on `capstone_raw`
- BigQuery Data Editor on your dataset

### ❌ Dataset not found
You used a dataset name in `profiles.yml` that doesn’t exist in BigQuery.

### ❌ Wrong keyfile path
Make sure the keyfile path is **absolute** and the file exists.

---

# 10. Using your own dataset name

If you want to avoid mixing your tables with other students:

1. In BigQuery: Ask Roberto to create your own dataset (e.g. `dbt_demo_lumi`)
2. Ensure you have access to it
3. Update `dataset:` in `profiles.yml`:
   ```yaml
   dataset: dbt_demo_lumi
   ```

