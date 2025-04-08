from flask import Flask, request, jsonify
import pickle
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer

app = Flask(__name__)

with open('spam_model.pkl', 'rb') as model_file:
    model = pickle.load(model_file)

with open('vectorizer.pkl', 'rb') as vectorizer_file:
    vectorizer = pickle.load(vectorizer_file)

spam_categories = {
    "Scam": ["win", "prize", "claim", "lottery", "congratulations", "winner"],
    "Promotion": ["free", "offer", "discount", "sale", "deal", "limited-time"],
    "Phishing": ["account", "verify", "login", "password", "bank", "urgent"],
    "Unknown": []
}

def get_category(message):
    message_lower = message.lower()
    for category, keywords in spam_categories.items():
        if any(keyword in message_lower for keyword in keywords):
            return category
    return "Unknown"

@app.route('/predict', methods=['POST'])
def predict():
    input_data = request.json.get('message', '')

    if not input_data:
        return jsonify({'error': 'No message provided'}), 400

    input_vector = vectorizer.transform([input_data])
    prediction_prob = model.predict_proba(input_vector)[0]
    prediction = np.argmax(prediction_prob)

    confidence_score = round(prediction_prob[prediction] * 100, 2)
    category = get_category(input_data)

    return jsonify({'prediction': 'spam' if prediction == 1 else 'ham', 'confidence': f"{confidence_score}%", 'category': category})

if __name__ == '__main__':
    app.run(debug=False)

