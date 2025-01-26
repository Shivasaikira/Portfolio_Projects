# Student Screen Time & Academic Insights

## 📚 Table of Contents
- [Problem Statement](#problem-statement)
- [Executive Summary](#executive-summary)
- [Data Analysis Workflow](#data-analysis-workflow)
- [Key Insights](#key-insights)
- [Recommendations ](#recommendations)
- [Conclusion](#conclusion)

---

## 🌍 Problem Statement
Analyzing the digital habits of tuition students and their correlation with academic performance.Tuition students were observed spending significant time on screens, raising concerns about its potential impact on their academic performance. To investigate this, an analysis was conducted on data collected from 12 students over 4 weekends in November 2024. The goal was to understand the correlation between their screen time, app usage patterns, and academic outcomes, and to provide actionable insights for better productivity and engagement. The aim is to provide actionable insights to improve productivity and engagement while maintaining a healthy balance between screen time and studies.

---

## 📝 Executive Summary
This project focuses on analyzing data collected from students regarding their weekend app usage, categorized by various parameters such as screen time, unlocks, notifications, and academic marks in math and science. The dashboard visually represents key performance indicators (KPIs) and trends, enabling stakeholders to identify areas of improvement and actionable strategies.

![ERD](https://github.com/Shivasaikira/Portfolio_Projects/blob/main/Student%20Screen%20Time%20Analysis/student-dashboard.png)
---

## 🔍 Data Analysis Workflow
1. **Data Preprocessing:**
   - During the data collection phase, all values for the 12 students were manually entered into separate columns in an Excel sheet. This dataset includes the relevant values for each student, which were then prepared for preprocessing
   - Cleaned and formatted the data for consistency.
   - Ensured dates were within November 2024 weekends.

2. **Pivot Table Analysis:**
   - Created Pivot Tables for key measures:
     - **Average Screen Time by Class**: Used "Average" function on screen time for each class.
     - **Engagement Rate by Class**: Calculated using the formula: 
       Engagement Rate =(Unlocks + Notifications)/(Screen Time) * 100 
     - **Top App Category**: Counted categories to identify the most used app type.

3. **Key Calculations:**
   - Correlation between screen time and marks using Excel’s `CORREL()` function.
   - Filtered data to identify clusters of students with high screen time and low marks.
   - Highlighted the peak hourly app usage trends.

4. **Visualizations:**
   - Created various charts to represent the data effectively:
     - Bar Chart: Screen time distribution and engagement rates by class.
     - Scatter Plot: Correlation between screen time and marks.
     - Line Chart: Hourly screen time trends.
     - Tree Map: App usage by category.
     - Pyramid Chart: App usage insights.
     - Pie Chart: Class-wise screen time insights.

---

## 🌟 Key Insights
1. **Average Screen Time:**
   - The overall average screen time is 31.8 minutes per session.
   - The student with the highest screen time usage is Ayush, with an average screen time of 61 minutes.

2. **Class-Wise Engagement:**
   - Class 12 students showed the highest engagement rate, followed by Class 10.
   - Engagement drops for younger students (Class 6).

3. **Correlation Analysis:**
   - A slight negative correlation (-0.2 to -0.3) between screen time and academic marks suggests excessive screen time may impact studies negatively.

4. **Peak Usage Insights:**
   - Peak screen time usage occurs at 6 PM.
   - Social media dominates app usage categories, followed by educational apps.

---

## 💡 Recommendations
1. **Screen Time Guidelines:**
   - Encourage reduced screen time, especially for students showing declining marks.
   - Promote balanced use of educational apps.
   - Focus more on educational apps while reducing time spent on social media and gaming apps.

2. **Engagement Strategies:**
   - Utilize peak hours (6 PM) for study-focused app interventions.
   - Tailor engagement strategies for Class 12 students to maintain their high focus.
   - Schedule specific times for leisure app usage to avoid distractions during study periods.

3. **Parental Awareness:**
   - Educate parents on monitoring app usage patterns and balancing digital habits.

---

## 🏁 Conclusion
This analysis sheds light on the interplay between digital habits and academic performance. The insights and recommendations aim to enhance productivity while fostering a balanced approach to technology use among students.

---



   


