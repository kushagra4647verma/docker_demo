import express from "express";
import cors from "cors";

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());

app.get("/health", (req, res) => {
  res.json({
    server: "Server 2 - Data API",
    status: "healthy",
    port: PORT,
    timestamp: new Date().toISOString(),
  });
});

app.get("/api/users", (req, res) => {
  res.json({
    users: [
      { id: 1, name: "Alice", email: "alice@example.com" },
      { id: 2, name: "Bob", email: "bob@example.com" },
      { id: 3, name: "Charlie", email: "charlie@example.com" },
    ],
  });
});

app.get("/api/products", (req, res) => {
  res.json({
    products: [
      { id: 1, name: "Laptop", price: 999 },
      { id: 2, name: "Phone", price: 599 },
      { id: 3, name: "Tablet", price: 399 },
    ],
  });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server 2 running on port ${PORT}`);
});
