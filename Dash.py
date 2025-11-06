import streamlit as st
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Page Config & Theme 
st.set_page_config(page_title="💼 Employee Dashboard", layout="wide")

st.markdown("""
    <style>
        .stApp {
            background-color: #0f1c2e;
            color: white;
        }
        h1, h2, h3, h4, h5, h6, p, label, .css-1v0mbdj, .css-1d391kg {
            color: white !important;
        }
        .stDataFrame, .stTable {
            background-color: #1e2a3a;
            color: white;
        }
        .stSidebar {
            background-color: #14213d;
        }
        .css-1cpxqw2, .css-1d391kg {
            background-color: #0f1c2e !important;
        }
    </style>
""", unsafe_allow_html=True)

# Load Data 
emp = pd.read_csv("EMP.csv")
sal = pd.read_csv("EMP_Sal.csv")
df = pd.merge(emp, sal, on="EID")

# Sidebar Filters
st.sidebar.title("🔍 Filter Employees")
departments = st.sidebar.multiselect("Select Department", df["DEPT"].unique())
min_salary = st.sidebar.slider("Minimum Base Pay", int(df["SALARY"].min()), int(df["SALARY"].max()), step=1000)

# Apply filters
filtered_df = df[
    (df["DEPT"].isin(departments) if departments else True) &
    (df["SALARY"] >= min_salary)
]

#  Dashboard Title 
st.title("💼 Employee Salary Dashboard")
st.markdown("Explore employee data and salary trends interactively.")

# KPIs 
col1, col2, col3 = st.columns(3)
col1.metric("👥 Total Employees", len(filtered_df))
col2.metric("💰 Avg. Base Pay", f"₹{filtered_df['SALARY'].mean():,.0f}")
col3.metric("🎁 Highest Bonus", f"₹{filtered_df['SALARY'].max():,.0f}")

# Salary Distribution
st.subheader("📊 Salary Distribution by Department")
sns.set_style("darkgrid")
fig, ax = plt.subplots()
sns.boxplot(data=filtered_df, x="DEPT", y="SALARY", ax=ax)
plt.xticks(rotation=45)
st.pyplot(fig)

# Data Table
st.subheader("📋 Employee Details")
st.dataframe(filtered_df)

# Download Button
st.download_button("📥 Download Filtered Data", filtered_df.to_csv(index=False), "filtered_employees.csv")