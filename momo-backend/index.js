require("dotenv").config();
const express = require("express");
const axios = require("axios");
const cors = require("cors");
const { randomUUID } = require("crypto");

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// MoMo API URLs
const COLLECTION_BASE_URL = "https://sandbox.momodeveloper.mtn.com/collection/v1_0";
const DISBURSEMENT_BASE_URL = "https://sandbox.momodeveloper.mtn.com/disbursement/v1_0";

// Collection API credentials
const COLLECTION_KEY = process.env.COLLECTION_SUBSCRIPTION_KEY;
const COLLECTION_USER = process.env.COLLECTION_API_USER;
const COLLECTION_API_KEY = process.env.COLLECTION_API_KEY;

// Disbursement API credentials
const DISBURSEMENT_KEY = process.env.DISBURSEMENT_SUBSCRIPTION_KEY;
const DISBURSEMENT_USER = process.env.DISBURSEMENT_API_USER;
const DISBURSEMENT_API_KEY = process.env.DISBURSEMENT_API_KEY;

// Root route for health check
app.get('/', (req, res) => {
  res.send('MoMo Backend is running!');
});

// 🔐 Get Access Token helper
async function getAccessToken(apiUser, apiKey, subscriptionKey, type = "collection") {
  const tokenUrl =
    type === "collection"
      ? "https://sandbox.momodeveloper.mtn.com/collection/token/"
      : "https://sandbox.momodeveloper.mtn.com/disbursement/token/";

  const response = await axios.post(tokenUrl, null, {
    headers: {
      "Ocp-Apim-Subscription-Key": subscriptionKey,
      Authorization: "Basic " + Buffer.from(`${apiUser}:${apiKey}`).toString("base64"),
    },
  });

  return response.data.access_token;
}

// 📲 Pay / Collection (User → App)
app.post("/pay", async (req, res) => {
  const { phone, amount, description, userId } = req.body;
  const referenceId = randomUUID();

  try {
    const token = await getAccessToken(COLLECTION_USER, COLLECTION_API_KEY, COLLECTION_KEY, "collection");

    await axios.post(
      `${COLLECTION_BASE_URL}/requesttopay`,
      {
        amount: amount,
        currency: "EUR", // sandbox-supported currency
        externalId: userId,
        payer: { partyIdType: "MSISDN", partyId: phone },
        payerMessage: "Payment to app",
        payeeNote: description,
      },
      {
        headers: {
          "X-Reference-Id": referenceId,
          "X-Target-Environment": "sandbox",
          "Ocp-Apim-Subscription-Key": COLLECTION_KEY,
          Authorization: `Bearer ${token}`,
        },
      }
    );

    res.json({ referenceId });
  } catch (e) {
    console.error("PAY ERROR:", e.response ? e.response.data : e.message);
    res.status(500).json({ error: e.response ? e.response.data : e.message });
  }
});

// 💸 Withdraw / Disbursement (App → User)
app.post("/withdraw", async (req, res) => {
  const { phone, amount, description, userId } = req.body;
  const referenceId = randomUUID();

  try {
    const token = await getAccessToken(DISBURSEMENT_USER, DISBURSEMENT_API_KEY, DISBURSEMENT_KEY, "disbursement");

    await axios.post(
      `${DISBURSEMENT_BASE_URL}/transfer`,
      {
        amount: amount,
        currency: "EUR", // sandbox-supported currency
        externalId: userId,
        payee: { partyIdType: "MSISDN", partyId: phone },
        payerMessage: "Withdrawal from app",
        payeeNote: description,
      },
      {
        headers: {
          "X-Reference-Id": referenceId,
          "X-Target-Environment": "sandbox",
          "Ocp-Apim-Subscription-Key": DISBURSEMENT_KEY,
          Authorization: `Bearer ${token}`,
        },
      }
    );

    res.json({ referenceId });
  } catch (e) {
    console.error("WITHDRAW ERROR:", e.response ? e.response.data : e.message);
    res.status(500).json({ error: e.response ? e.response.data : e.message });
  }
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
