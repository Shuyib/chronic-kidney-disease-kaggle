# chronic-kidney-disease-kaggle

The data consists of 25 features and 400 observations consisting of various features that could be used to predict chronic kidney disease. The original dataset is available [UCI Machine Learning repository](https://archive.ics.uci.edu/ml/datasets/ChronicKidneyDisease) and you can find the kaggle dataset [here](https://www.kaggle.com/mansoordaku/ckdisease). I use data cleaning and data transformation techniques in cluding data compression techniques for example PCA (Principal Component Analysis) to evaluate the performance of Logistic regression and decision tree classifiers. 

Here are the final scores: 

Logistic regression without standard scaler: F1-Score: 0.992  
Decision tree classifier without standard scaler: F1-Score: 0.959  

Logistic regression with standard scaler: F1-Score: 0.976  
Logistic regression with standard scaler and PCA: F1-Score: 0.625  
Decision tree classifier with standard scaler and PCA: F1-Score: 0.879  

Within the [notebook](https://github.com/Shuyib/chronic-kidney-disease-kaggle/blob/main/chronic-kidney-disease-eda-and-prediction.ipynb) we go over feature importance for each classifier and also interpret what the results mean to the patient and the progression of the disease. How they relate to diagnostic tests for kidney function expose about the patients' condition? Just for reading use [this](https://github.com/Shuyib/chronic-kidney-disease-kaggle/blob/main/chronic-kidney-disease-eda-and-prediction.html). You can also make my kaggle environment using the `pip install -r requirements.txt`. Use a virtual environment so as not disturb what you already have learn how to create one using the [official documentation](https://docs.python.org/3/tutorial/venv.html) or [using anaconda](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-with-commands).

Lastly they are tasks you can try out to further improve and refine the models further. Check them out maybe you'll learn something. Feel free to reach out to talk about the results further. 

# How to run the docker image

Build docker image  
```bash
docker build -t chronic-kidney-disease-kaggle .
```

Run the Docker image  
```bash
docker run -it -p 9999:9999 chronic-kidney-disease:latest
```
