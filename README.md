# Churn-Prediction
In this article, I discuss how to identify our beloved customers at a high risk of leaving us through implementing logistic regression and random forest models with Python. The practical case is about an E-learning platform’s user churn, while the modeling and code are generalizable to any business scenario dealing with churn prediction.

What is churn and why churn prediction is important?
Churn refers to the customers who have stopped coming back to our business. Identifying a particular customer at a high risk of churn, while there is still time to take intervention about it, is an essential task for every business. After all, attracting new customers can be five to twenty-five times more expensive than retaining existing ones, according to Harvard Business Review.
Use case
The basic idea of churn prediction is to construct a supervised learning model based on user data from the past. In this post, I will showcase the churn prediction step by step through a data science project I delivered for PositivePhysics. This is an E-learning platform for high school teachers to assign physics practices and assessments to their students. As it is the teacher who decides to use this platform, I will focus this project on identifying teachers’ potential churn.
