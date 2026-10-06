from flask import Flask, request, jsonify
from flask_cors import CORS
import pickle
import numpy as np


# ============================================================
# FLASK APP
# ============================================================

app = Flask(__name__)
CORS(app)


# ============================================================
# LOAD TRAINED MODEL
# ============================================================

with open("spam_model.pkl", "rb") as model_file:
    model = pickle.load(model_file)

with open("vectorizer.pkl", "rb") as vectorizer_file:
    vectorizer = pickle.load(vectorizer_file)

print("Spam detection model loaded successfully!")
print("Vectorizer loaded successfully!")


# ============================================================
# SPAM CATEGORIES
# ============================================================

SPAM_CATEGORIES = {
    "Scam": [
        "win",
        "winner",
        "won",
        "prize",
        "claim",
        "lottery",
        "congratulations",
        "reward",
        "jackpot",
        "cash prize",
        "you have won"
    ],

    "Promotion": [
        "free",
        "offer",
        "discount",
        "sale",
        "deal",
        "promo",
        "promotion",
        "limited time",
        "buy now",
        "special offer",
        "save",
        "voucher",
        "coupon"
    ],

    "Phishing": [
        "verify your account",
        "verify account",
        "login",
        "log in",
        "password",
        "username",
        "bank",
        "bank account",
        "account verification",
        "confirm your account",
        "security alert",
        "click the link",
        "update your account"
    ],

    "Financial Scam": [
        "loan",
        "investment",
        "profit",
        "credit",
        "debit",
        "refund",
        "payment",
        "transfer money",
        "send money",
        "wire transfer",
        "bitcoin",
        "crypto"
    ]
}


# ============================================================
# NORMAL MESSAGE CATEGORIES
# ============================================================

NORMAL_CATEGORIES = {
    "Personal": [
        "mom",
        "dad",
        "mother",
        "father",
        "brother",
        "sister",
        "friend",
        "family",
        "home",
        "dinner",
        "lunch",
        "tomorrow",
        "tonight",
        "meet",
        "meeting",
        "call me",
        "see you",
        "how are you",
        "thank you",
        "thanks"
    ],

    "Work": [
        "meeting",
        "project",
        "office",
        "work",
        "client",
        "team",
        "deadline",
        "report",
        "presentation",
        "interview",
        "developer",
        "manager"
    ],

    "Transaction": [
        "transaction",
        "receipt",
        "order",
        "delivery",
        "delivered",
        "payment received",
        "payment successful",
        "order confirmed",
        "booking",
        "invoice"
    ]
}


# ============================================================
# CATEGORY DETECTION
# ============================================================

def get_category(message, prediction):
    """
    Determines the category after the ML model
    has already decided whether the message is spam or ham.
    """

    message_lower = message.lower().strip()

    # --------------------------------------------------------
    # NORMAL MESSAGE
    # --------------------------------------------------------

    if prediction == 0:

        category_scores = {}

        for category, keywords in NORMAL_CATEGORIES.items():

            score = 0

            for keyword in keywords:
                if keyword in message_lower:
                    score += 1

            category_scores[category] = score

        best_category = max(
            category_scores,
            key=category_scores.get
        )

        if category_scores[best_category] > 0:
            return best_category

        return "Normal"


    # --------------------------------------------------------
    # SPAM MESSAGE
    # --------------------------------------------------------

    category_scores = {}

    for category, keywords in SPAM_CATEGORIES.items():

        score = 0

        for keyword in keywords:
            if keyword in message_lower:
                score += 1

        category_scores[category] = score

    best_category = max(
        category_scores,
        key=category_scores.get
    )

    if category_scores[best_category] > 0:
        return best_category

    return "Suspicious"


# ============================================================
# PREDICTION API
# ============================================================

@app.route("/predict", methods=["POST"])
def predict():

    # --------------------------------------------------------
    # GET JSON DATA
    # --------------------------------------------------------

    data = request.get_json(silent=True)

    if not data:
        return jsonify({
            "error": "Invalid JSON request"
        }), 400

    input_data = data.get("message", "")

    if not isinstance(input_data, str):
        return jsonify({
            "error": "Message must be text"
        }), 400

    input_data = input_data.strip()

    if not input_data:
        return jsonify({
            "error": "No message provided"
        }), 400


    # --------------------------------------------------------
    # VECTORIZATION
    # --------------------------------------------------------

    input_vector = vectorizer.transform([input_data])


    # --------------------------------------------------------
    # MODEL PREDICTION
    # --------------------------------------------------------

    prediction_prob = model.predict_proba(input_vector)[0]

    prediction = np.argmax(prediction_prob)

    confidence_score = round(
        prediction_prob[prediction] * 100,
        2
    )


    # --------------------------------------------------------
    # CATEGORY
    # --------------------------------------------------------

    category = get_category(
        input_data,
        prediction
    )


    # --------------------------------------------------------
    # FINAL RESULT
    # --------------------------------------------------------

    result = {
        "prediction": "spam" if prediction == 1 else "ham",
        "confidence": f"{confidence_score}%",
        "category": category
    }

    return jsonify(result)


# ============================================================
# START SERVER
# ============================================================

if __name__ == "__main__":

    print("========================================")
    print("SpamX API Server")
    print("========================================")
    print("Server running on port 5000")
    print("Waiting for Flutter requests...")
    print("========================================")

    app.run(
        host="0.0.0.0",
        port=5000,
        debug=False
    )
