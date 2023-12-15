const express = require("express");
const asyncHandler = require("express-async-handler");
const bodyParser = require("body-parser");
const cors = require("cors");
const { Pool } = require("pg");
const app = express();
const port = 5000;

app.use(bodyParser.json());
app.use(cors());

const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "CC",
  password: "R.kis007",
  port: 5432,
});

// Endpoint to store template details
app.get(
  "/api/templates",
  asyncHandler(async (req, res) => {
    try {
      const client = await pool.connect();
      const result = await client.query("SELECT * FROM TEMPLATES_MASTER");
      client.release();
      const templates = result.rows;
      res.status(200).json(templates);
    } catch (error) {
      console.error("Error fetching templates:", error);
      res.status(500).json({ error: "Internal Server Error" });
    }
  })
);
app.post(
  "/api/store-template",
  asyncHandler(async (req, res) => {
    // console.log(req.body);
    const {
      NAME,
      INSTITUTION_ID,
      FILE_PATH,
      FILE_NAME,
      CREATED_BY,
      MODIFIED_BY,
      ACTIVE,
      remarks,
    } = req.body;

    try {
      const client = await pool.connect();

      // Insert template details into the database
      const insertQuery = `
      INSERT INTO TEMPLATES_MASTER (NAME, INSTITUTION_ID, FILE_PATH, FILE_NAME, CREATED_BY, MODIFIED_BY, ACTIVE, REMARKS)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      RETURNING ID;
    `;
      const insertValues = [
        NAME,
        INSTITUTION_ID,
        FILE_PATH,
        FILE_NAME,
        CREATED_BY || "SYSTEM",
        MODIFIED_BY || "SYSTEM",
        ACTIVE || "Y",
        remarks || null,
      ];

      const result = await client.query(insertQuery, insertValues);

      const templateId = result.rows[0].id;

      client.release();

      res
        .status(201)
        .json({ message: "Template stored successfully", templateId });
    } catch (error) {
      console.error("Error storing template:", error);
      res.status(500).json({ error: "Internal Server Error" });
    }
  })
);

// Add more template-related endpoints as needed
// ...

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
