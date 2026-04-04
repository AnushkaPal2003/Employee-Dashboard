# 📊 Employee Data Analysis & Business Insights using SQL

## 📌 Project Overview
This project focuses on analyzing employee and salary data using SQL to derive meaningful business insights. The goal is to understand salary distribution, department performance, hiring trends, and identify potential inefficiencies within the organization.

## 🧠 Objectives
- Analyze employee and salary data
- Identify salary trends across departments and cities
- Detect data quality issues such as missing or duplicate records
- Generate business insights to support decision-making

## 📂 Dataset Description

The dataset consists of two tables:

### 1. emp
Contains employee details:
- Employee ID (eid)
- Name
- City
- Date of Birth (DOB)
- Date of Joining (DOJ)
- Email
- Phone Number

### 2. emp_sal
Contains salary-related details:
- Employee ID (eid)
- Department (dept)
- Salary
- Designation (desi)

Both tables are joined using **Employee ID (eid)**.

## 🧹 Data Cleaning & Preprocessing

Performed several data cleaning operations:
- Identified missing salary records
- Detected employees without salary information
- Removed duplicate employee records
- Standardized date formats (YYYY-MM-DD)
- Converted emails to lowercase
- Formatted phone numbers to +91 format
- Validated data integrity (checked orphan records)

## 🔍 Exploratory Data Analysis (EDA)

### ✔ Basic Analysis
- Retrieved employee details with salary and department
- Identified employees without salary records

### ✔ Salary Analysis
- Average salary per department
- Minimum, maximum, and distribution of salaries
- Salary comparison across designations

### ✔ Hiring Trends
- Number of employees joined per year

### ✔ Advanced Analysis
- Highest-paid employee per department
- Ranking employees based on salary
- Second-highest salary in each department
- Cumulative salary distribution

### ✔ Data Quality Checks
- Duplicate records
- Missing salary data
- Orphan salary records

## 📈 Business Insights

- 📍 **Delhi has the highest average salary**, indicating higher-paying roles or cost of living impact.
- 📉 **Certain departments have lower average salaries**, indicating possible underpayment or junior workforce concentration.
- 👥 **Significant salary gap exists between designations (Associate, Manager, VP)**.
- 📅 **Hiring trends show variation across years**, helping understand company growth phases.
- ⚠️ **Some employees lack salary records**, highlighting data inconsistencies.

## 🛠 Tools & Technologies Used

- SQL (Joins, Aggregations, Window Functions, Data Cleaning)
- Microsoft SQL Server

## 🚀 Key Skills Demonstrated

- Data Cleaning & Preprocessing
- SQL Query Optimization
- Business-Oriented Data Analysis
- Analytical Thinking
- Data Validation & Integrity Checks

## 📌 Conclusion

This project demonstrates how SQL can be effectively used to analyze structured data and generate actionable business insights. It highlights the importance of data quality, analytical thinking, and the ability to translate raw data into meaningful conclusions.

