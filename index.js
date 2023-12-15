const express = require("express");
const errorHandler = require("./middleware/errorHandler");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());
app.use("/api/user", require("./routes/userRoutes"));
app.get("/api/institution-details", require("./routes/userRoutes"));
app.get("/api/secret-questions", require("./routes/userRoutes"));
app.post("/api/register", require("./routes/userRoutes"));
app.post("/api/login", require("./routes/userRoutes"));
app.post("/api/fotp", require("./routes/userRoutes"));
app.post("/api/forP", require("./routes/userRoutes"));
app.get("/api/templates", require("./routes/userRoutes"));
app.post("/api/download-template", require("./routes/userRoutes"));
app.post("/api/uploadCertificateRequest",require("./routes/userRoutes"))
app.use(errorHandler);

app.listen(process.env.PORT, () => {
  console.log("Server is running in port " + process.env.PORT);
});
