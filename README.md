# 🛡️ SpamX

### AI-Powered Message Security

SpamX is a Flutter-based mobile application that uses machine learning to analyze messages and detect potential spam, scams, phishing attempts, promotions, and suspicious content.

The app combines a **Flutter mobile interface** with a **Python Flask REST API** and a machine-learning classification pipeline to provide real-time message analysis, confidence scores, and threat categories.

---

## ✨ Features

* 🔍 **Smart Message Detection** — Analyze messages for potential spam and suspicious content.
* 🤖 **Machine Learning Classification** — Uses TF-IDF features and Logistic Regression for text classification.
* 🛡️ **Threat Categorization** — Identifies categories such as Scam, Phishing, Promotion, Financial Scam, Suspicious, and Normal.
* 📊 **Confidence Score** — Displays the model's confidence for each prediction.
* 🎙️ **Voice Input** — Analyze messages using speech-to-text input.
* 📈 **Activity & Insights** — Visualize message analysis and detection statistics.
* 🌙 **Modern Cybersecurity UI** — Dark, AI-inspired interface designed for a clean mobile experience.

---

## 🧠 Machine Learning

SpamX uses a text-classification pipeline built with **scikit-learn**.

### Model Pipeline

```text
Input Message
      │
      ▼
┌─────────────────────┐
│   Text Processing   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────┐
│ TF-IDF Feature Extraction   │
│                             │
│ • Word n-grams              │
│ • Character n-grams         │
└────────────┬────────────────┘
             │
             ▼
┌─────────────────────────────┐
│   Logistic Regression       │
└────────────┬────────────────┘
             │
             ▼
┌─────────────────────────────┐
│ Spam / Ham Classification   │
└────────────┬────────────────┘
             │
             ▼
┌─────────────────────────────┐
│ Category + Confidence Score │
└─────────────────────────────┘
```

### Model Performance

The current model achieved:

| Metric            |     Result |
| ----------------- | ---------: |
| Test Accuracy     | **99.19%** |
| Weighted F1 Score |   **~99%** |
| Spam F1 Score     |    **97%** |

The model uses both **word-level and character-level TF-IDF features**, combined through a feature union before classification.

---

## 🏗️ Architecture

```text
┌──────────────────────────┐
│      Flutter App         │
│        (Dart)            │
└────────────┬─────────────┘
             │
             │ HTTP / JSON
             ▼
┌──────────────────────────┐
│       Flask API          │
│        (Python)          │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│   TF-IDF Vectorizer      │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│  Logistic Regression     │
│      ML Classifier       │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│ Prediction + Confidence  │
│       + Category         │
└──────────────────────────┘
```

---

## 🛠️ Tech Stack

### Frontend

* **Flutter**
* **Dart**
* `flutter_animate`
* `fl_chart`
* `speech_to_text`
* `permission_handler`

### Backend

* **Python**
* **Flask**
* **Flask-CORS**
* REST API

### Machine Learning

* **scikit-learn**
* TF-IDF Vectorization
* Word & Character n-grams
* Feature Union
* Logistic Regression

### Development

* Git & GitHub
* Android Studio
* Flutter SDK

---

## 🔌 API

SpamX communicates with the Flask backend through a REST API.

### Endpoint

```http
POST /predict
```

### Request

```json
{
  "message": "Congratulations! You have won a free prize!"
}
```

### Response

```json
{
  "prediction": "spam",
  "confidence": "82.74%",
  "category": "Scam"
}
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have installed:

* Flutter SDK
* Dart SDK
* Python 3.x
* Git

### 1. Clone the repository

```bash
git clone https://github.com/ayshafidhakr/spamX.git
cd spamX
```

### 2. Install Flutter dependencies

```bash
flutter pub get
```

### 3. Install Python dependencies

```bash
pip install -r requirements.txt
```

### 4. Start the Flask API

```bash
python app.py
```

The API runs on port `5000` by default.

### 5. Run the Flutter application

```bash
flutter run
```

---

## 📦 Project Structure

```text
SpamX/
│
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
│
├── assets/
│   └── logo_spamX.png
│
├── lib/
│   ├── main.dart
│   ├── splash_screen.dart
│   └── intro_screen.dart
│
├── app.py
├── model_train.py
├── models.py
├── spam_model.pkl
├── vectorizer.pkl
│
├── requirements.txt
├── Procfile
├── pubspec.yaml
├── pubspec.lock
├── README.md
└── LICENSE
```

---

## ⚠️ Current Limitations

The current model performs strongly on the evaluation dataset, but machine-learning models can still produce incorrect predictions for messages that differ significantly from their training data.

SpamX should therefore be treated as a **decision-support tool rather than a guarantee that a message is safe or malicious**.

The current API is also configured for development/local testing. A production deployment will use a publicly accessible HTTPS endpoint.

---

## 🔮 Future Improvements

* 🌐 Deploy the Flask API to a production environment
* 🔐 Add secure authentication and API protection
* 🧠 Improve the training dataset and model generalization
* 🎯 Improve detection of phishing and account-compromise messages
* 📱 Publish the application as an Android release
* 📊 Expand analytics and detection history
* ⚡ Optimize API response time
* 🧪 Add automated model evaluation and testing

---

## 👩‍💻 Author

**Aysha F.**

Built as a full-stack machine-learning application combining mobile development, REST APIs, and natural-language text classification.

---

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.
