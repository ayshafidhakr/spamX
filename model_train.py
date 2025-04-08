import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB
from imblearn.over_sampling import RandomOverSampler  # To balance dataset
import pickle

# Step 1: Load the dataset
data = pd.read_csv("D:/Downloads/spam.csv", encoding='latin1')
print("Dataset loaded successfully!")

# Step 2: Clean dataset (use 'Category' and 'Message' columns)
data = data[['Category', 'Message']].rename(columns={'Category': 'label', 'Message': 'message'})

# Map 'ham' to 0 and 'spam' to 1
data['label'] = data['label'].map({'ham': 0, 'spam': 1})

# Step 3: Text Preprocessing - Use TF-IDF instead of CountVectorizer
X = data['message']
y = data['label']

vectorizer = TfidfVectorizer(max_features=5000)  # Limit to 5000 important words
X_vectorized = vectorizer.fit_transform(X)

# Step 4: Balance the Dataset (Fixes Spam Bias)
oversampler = RandomOverSampler(random_state=42)
X_balanced, y_balanced = oversampler.fit_resample(X_vectorized, y)

# Step 5: Train-Test Split
X_train, X_test, y_train, y_test = train_test_split(X_balanced, y_balanced, test_size=0.2, random_state=42)

# Step 6: Train the Multinomial Naive Bayes model
model = MultinomialNB()
model.fit(X_train, y_train)
print("Model trained successfully!")

# Step 7: Save the trained model and vectorizer
with open('spam_model.pkl', 'wb') as model_file:
    pickle.dump(model, model_file)

with open('vectorizer.pkl', 'wb') as vectorizer_file:
    pickle.dump(vectorizer, vectorizer_file)

print("Model and vectorizer saved successfully as 'spam_model.pkl' and 'vectorizer.pkl'.")
