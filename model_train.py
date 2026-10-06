import pickle
import pandas as pd

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.pipeline import FeatureUnion
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report


# ============================================================
# 1. DATASET
# ============================================================

DATASET_PATH = "D:/Downloads/spam.csv"

data = pd.read_csv(DATASET_PATH, encoding="latin1")

print("Dataset loaded successfully!")


# ============================================================
# 2. CLEAN DATA
# ============================================================

data = data[["Category", "Message"]].rename(
    columns={
        "Category": "label",
        "Message": "message"
    }
)

data = data.dropna(subset=["label", "message"])

data["label"] = data["label"].str.lower().str.strip()

data["label"] = data["label"].map({
    "ham": 0,
    "spam": 1
})

data = data.dropna(subset=["label"])

data["label"] = data["label"].astype(int)


print(f"Total messages: {len(data)}")
print(f"Ham messages: {(data['label'] == 0).sum()}")
print(f"Spam messages: {(data['label'] == 1).sum()}")


# ============================================================
# 3. SPLIT DATA
# ============================================================

X = data["message"]
y = data["label"]

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42,
    stratify=y
)


# ============================================================
# 4. WORD TF-IDF
# ============================================================

word_vectorizer = TfidfVectorizer(
    lowercase=True,
    strip_accents="unicode",
    sublinear_tf=True,
    ngram_range=(1, 2),
    min_df=1,
    max_df=0.98,
    max_features=50000
)


# ============================================================
# 5. CHARACTER TF-IDF
# ============================================================

char_vectorizer = TfidfVectorizer(
    analyzer="char",
    lowercase=True,
    sublinear_tf=True,
    ngram_range=(3, 5),
    min_df=2,
    max_features=50000
)


# ============================================================
# 6. COMBINE WORD + CHARACTER FEATURES
# ============================================================

vectorizer = FeatureUnion([
    ("word", word_vectorizer),
    ("char", char_vectorizer)
])


print("\nCreating TF-IDF features...")

X_train_vectorized = vectorizer.fit_transform(X_train)
X_test_vectorized = vectorizer.transform(X_test)


print("Feature creation completed!")


# ============================================================
# 7. TRAIN MODEL
# ============================================================

print("\nTraining Logistic Regression model...")

model = LogisticRegression(
    max_iter=1000,
    class_weight="balanced",
    C=3.0
)

model.fit(X_train_vectorized, y_train)

print("Model trained successfully!")


# ============================================================
# 8. TEST MODEL
# ============================================================

predictions = model.predict(X_test_vectorized)

accuracy = accuracy_score(
    y_test,
    predictions
)

print("\n========================================")
print(f"MODEL ACCURACY: {accuracy * 100:.2f}%")
print("========================================\n")

print(
    classification_report(
        y_test,
        predictions,
        target_names=["Ham", "Spam"]
    )
)


# ============================================================
# 9. SAVE MODEL + VECTORIZER
# ============================================================

MODEL_PATH = "spam_model.pkl"
VECTORIZER_PATH = "vectorizer.pkl"


with open(MODEL_PATH, "wb") as model_file:
    pickle.dump(model, model_file)


with open(VECTORIZER_PATH, "wb") as vectorizer_file:
    pickle.dump(vectorizer, vectorizer_file)


print("========================================")
print("Model saved as:", MODEL_PATH)
print("Vectorizer saved as:", VECTORIZER_PATH)
print("========================================")
