# Data Warehouse

Welcome to the **Data Warehouse** repository 🚀  
This project is a hands-on implementation of a complete data warehousing pipeline — from raw data ingestion all the way to generating meaningful insights. It focuses on practical design decisions and real-world data engineering workflows rather than just theory.

---

![Data Architecture](images/architecture.png)

---

## 🏗️ Data Architecture

The project is built around the **Medallion Architecture**, structured into three layers:

### Bronze Layer
Raw data is ingested directly from source systems (CSV files) into SQL Server without any transformation. This layer acts as the single source of truth and preserves original data.

### Silver Layer
Data is cleaned, standardized, and normalized. This is where inconsistencies, missing values, and formatting issues are handled to make the data reliable.

### Gold Layer
Data is transformed into a business-friendly format using a **star schema**. This layer is optimized for reporting, analytics, and querying performance.

---

## 📖 Project Overview

This project covers the full lifecycle of building a data warehouse:

- Designing a layered data architecture (Bronze, Silver, Gold)  
- Building ETL pipelines to move and transform data  
- Creating fact and dimension tables for efficient querying  
- Writing analytical queries to extract insights from the data  

Instead of focusing only on tools, the goal here is to understand *why* things are designed in a certain way and how they scale in real scenarios.

### What this project demonstrates

- Writing structured and efficient SQL  
- Designing scalable data models  
- Building ETL workflows from scratch  
- Handling messy, real-world data  
- Turning raw data into useful insights  

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

**Objective**  
Build a structured and reliable data warehouse using SQL Server that can support reporting and analytical use cases.

### What’s involved

- **Data Sources**  
  Multiple CSV files are used to simulate data coming from different systems (like ERP/CRM).

- **Data Quality Handling**  
  Cleaning bad data, handling missing values, and fixing inconsistencies before it reaches the final layer.

- **Data Integration**  
  Combining different sources into a unified schema designed specifically for analytics.

- **Documentation**  
  Keeping the data model understandable so it can actually be used by others (analysts, developers, etc.), not just built and forgotten.

---
