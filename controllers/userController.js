const axios = require("axios");
require("dotenv").config();
const IP = require("ip");
const asyncHandler = require("express-async-handler");
const dbPool = require("../config/dbConnection");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const logger = require("./logger");
const xlsxFile = require("read-excel-file/node");
const multer = require("multer");
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  },
});
const upload = multer({ storage: storage }).single("file");
//@desc Get All User
//@route GET /api/user
//@access Public
const getAllUser = asyncHandler(async (req, res) => {
  //dbPool  - write sql here
  res.status(200).json({ message: `Get all user End Point of User` });
});

const institution = asyncHandler(async (req, res) => {
  const client = await dbPool.connect();
  const result = await client.query("SELECT * FROM INSTITUTION_MASTER");
  client.release();
  const institutionDetails = result.rows;
  res.status(200).json(institutionDetails);
});

const question = asyncHandler(async (req, res) => {
  const client = await dbPool.connect();
  const result = await client.query("SELECT * FROM SECRET_QUESTIONS");
  client.release();
  const questions = result.rows;
  res.status(200).json(questions);
});

er = [];
const register = asyncHandler(async (req, res) => {
  let ParentInstitution;
  er = [];
  const {
    UserName,
    Email,
    Password,
    Institution,
    Question1,
    Answer1,
    Question2,
    Answer2,
  } = req.body;

  if (!/^[A-Za-z0-9.@_]{8,30}$/.test(UserName)) {
    er.push({ message: 10 });
  }

  if (
    !/^(?=.[0-9])(?=.[a-z])(?=.[A-Z])(?=.[!@#$%^&.])[a-zA-Z0-9.!@#$%^&]{8,20}$/.test(
      Password
    )
  ) {
    er.push({ message: 12 });
  }

  if (!/^.+@.+\..+$/.test(Email)) {
    er.push({ message: 11 });
  }

  if (
    !Number.isInteger(Institution) ||
    !Number.isInteger(Question1) ||
    !Number.isInteger(Question2)
  ) {
    er.push({ message: 14 });
  }

  try {
    const client = await dbPool.connect();

    const existingUserQuery = `
      SELECT * FROM login_details
      WHERE username = $1 OR email_id = md5($2)
    `;
    const existingUserValues = [UserName, Email];
    const existingUserResult = await client.query(
      existingUserQuery,
      existingUserValues
    );

    if (existingUserResult.rows.length > 0) {
      client.release();
      logger.error(`Failed signin attempt for ip address: ${IP.address()}`);
      er.push({
        message: "User with the same username or email already exists",
      });
    }
    if (er.length) {
      return res.status(400).json({ er });
    }

    const institutionQuery = `
      SELECT parent_institution_id FROM institution_master
      WHERE id = $1
    `;
    const institutionValues = [Institution];
    const institutionResult = await client.query(
      institutionQuery,
      institutionValues
    );

    if (institutionResult.rows.length > 0) {
      ParentInstitution = institutionResult.rows[0].parent_institution_id;
    }
    const insertUserQuery = `
      INSERT INTO login_details (username, email_id, password, institution_id, parent_institution_id, secret_question_1_id, secret_answer_1, secret_question_2_id, secret_answer_2)
      VALUES ($1, md5($2), md5($3), $4, $5, $6, md5($7), $8, md5($9))
    `;
    const insertUserValues = [
      UserName,
      Email,
      Password,
      Institution,
      ParentInstitution,
      Question1,
      Answer1,
      Question2,
      Answer2,
    ];

    const result = await client.query(insertUserQuery, insertUserValues);
    client.release();
    res.json({ message: "Data inserted successfully" });
  } catch (error) {
    logger.error(`Failed signin attempt for ip address: ${IP.address()}`);
    console.error("Error handling the POST request:", error);
    res.status(500).json({ success: false, message: "An error occurred" });
  }
});

const storeLoginAttempt = async (loginAttempt) => {
  const {
    user_id,
    login_timestamp,
    success,
    error_reason,
    ip_address,
    user_agent,
    username,
    email,
    timestamp,
  } = loginAttempt;

  const query = `
    INSERT INTO USER_LOGIN_ATTEMPTS (user_id, login_timestamp, success, error_reason, ip_address, user_agent, username, email, timestamp)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
  `;
  const values = [
    user_id,
    login_timestamp,
    success,
    error_reason,
    ip_address,
    user_agent,
    username,
    email,
    timestamp,
  ];

  try {
    await dbPool.query(query, values);
  } catch (error) {
    console.error("Error storing login attempt:", error);
  }
};

async function storeUserSession(token, userId, loginTimestamp) {
  const expirationTimestamp = new Date(loginTimestamp);
  expirationTimestamp.setHours(expirationTimestamp.getHours() + 6);
  // console.log(expirationTimestamp);
  const query = `
    INSERT INTO USER_SESSIONS (SESSION_ID, USER_ID, LOGIN_TIMESTAMP, EXPIRATION_TIMESTAMP)
    VALUES ($1, $2, $3, $4)
  `;
  const values = [token, userId, loginTimestamp, expirationTimestamp];

  try {
    await dbPool.query(query, values);
  } catch (error) {
    console.error("Error storing user session:", error);
  }
}

const login = asyncHandler(async (req, res) => {
  const secretKey = process.env.ACCESS_TOKEN_SECRET;
  const { UserName, Password } = req.body;
  const client = await dbPool.connect();
  const query = `
    SELECT institution_id AS institutionid, id AS userid, username, email_id
    FROM login_details 
    WHERE username = $1 AND password = md5($2)
  `;
  const values = [UserName, Password];
  try {
    const result = await client.query(query, values);
    const success = result.rows.length > 0;
    const user = result.rows[0];

    if (!user) {
      // const loginAttempt = {
      //   username: UserName,
      //   email: null,
      //   timestamp: new Date(),
      //   success: false,
      //   user_id: null,
      //   login_timestamp: new Date(),
      //   error_reason: "Invalid User",
      //   ip_address: IP.address(),
      //   user_agent: req.headers["user-agent"],
      // };
      // await storeLoginAttempt(loginAttempt);
      logger.error(
        `Failed login attempt for username: ${UserName} ipaddress: ${IP.address()}`
      );
      return res.status(401).json({ message: "Invalid User" });
    }

    const institutionId = user.institutionid;
    const userId = user.userid;
    const loginAttempt = {
      username: user.username,
      email: user.email_id,
      timestamp: new Date(),
      success: success,
      user_id: userId,
      login_timestamp: new Date(),
      error_reason: success,
      ip_address: IP.address(),
      user_agent: req.headers["user-agent"],
    };
    await storeLoginAttempt(loginAttempt);

    if (success) {
      const token = jwt.sign(
        {
          iss: "ccbe",
          sub: institutionId,
          aud: userId,
          exp: Math.floor(Date.now() / 1000) + 6 * 60 * 60,
          iat: Math.floor(Date.now() / 1000),
          scope: "full",
        },
        secretKey
      );
      const loginTimestamp = new Date();
      //below line for store session in db
      // await storeUserSession(token, userId, loginTimestamp);
      logger.info(
        `Successful login for username: ${
          user.username
        } ipaddress:${IP.address()}`
      );
      res
        .header("sessionId", token)
        .json({ Header: token, message: "Login successful" });
    } else {
      res.status(401).json({ message: "Invalid User" });
    }
  } catch (error) {
    console.error("Error: ", error);
    res.status(500).json({ success: false, message: "An error occurred" });
  } finally {
    client.release();
  }
});

const fotp = asyncHandler(async (req, res) => {
  const { email } = req.body;
  const client = await dbPool.connect();

  try {
    const query = `
      SELECT secret_question_1_id AS q1_id, secret_question_2_id AS q2_id
      FROM login_details
      WHERE email_id = md5($1)
    `;
    const values = [email];
    const result = await client.query(query, values);

    if (result.rows.length == 0) {
      return res.status(404).json({ message: "User not found" });
    }

    const { q1_id, q2_id } = result.rows[0];

    const innerQuery = `
      SELECT *
      FROM SECRET_QUESTIONS
      WHERE question_id = $1 OR question_id = $2
    `;
    const innerValues = [q1_id, q2_id];
    const innerResult = await client.query(innerQuery, innerValues);

    if (innerResult.rows.length != 2) {
      return res.status(400).json({
        message: "Not all questions are active. Please contact Admin.",
      });
    }

    const activeQuestions = innerResult.rows.filter(
      (question) => question.active === "A"
    );

    if (activeQuestions.length != 2) {
      return res.status(400).json({
        message: "Not all questions are active. Please contact Admin.",
      });
    }

    res.json({
      header: "User found",
      message: activeQuestions,
    });
  } catch (error) {
    console.error("Error: ", error);
    res.status(500).json({ message: "An error occurred" });
  } finally {
    client.release();
  }
});

const forP = asyncHandler(async (req, res) => {
  const { email, answer1, answer2 } = req.body;
  const client = await dbPool.connect();
  try {
    const query = `
      SELECT secret_answer_1 as a1, secret_answer_2 as a2
      FROM login_details 
      WHERE email_id = md5($1)
    `;
    const values = [email];
    const result = await client.query(query, values);

    if (result.rows.length == 0) {
      return res.status(404).json({ message: "User not found" });
    }

    const { a1, a2 } = result.rows[0];
    if (answer1 === a1 && answer2 === a2) {
      return res.json({ message: "Answers match" });
    } else {
      return res.status(400).json({ message: "Answers do not match" });
    }
  } catch (error) {
    console.error("Error: ", error);
    res.status(500).json({ message: "An error occurred" });
  } finally {
    client.release();
  }
});

//for verofy the jwt token
const verifyToken = (req, res, next) => {
  const secretKey = process.env.ACCESS_TOKEN_SECRET;
  const token = req.headers.authorization;
  // console.log("Received Token:", token);
  if (!token) {
    return res.status(403).json({ message: "No token provided" });
  }
  const tokenWithoutBearer = token.replace("Bearer ", "");
  // console.log("token withoutBearer:",tokenWithoutBearer);
  jwt.verify(tokenWithoutBearer, secretKey, (err, decoded) => {
    // console.log("Decoded JWT:", decoded);
    if (err) {
      return res.status(401).json({ message: "Unauthorized" });
    }
    req.institutionId = decoded.sub;
    next();
  });
};

//

const getTemplates = asyncHandler(async (req, res) => {
  try {
    verifyToken(req, res, async () => {
      const institutionId = req.institutionId;
      // console.log(institutionId);
      const client = await dbPool.connect();
      const query = `
        SELECT id AS templateId, name AS templateName
        FROM TEMPLATES_MASTER
        WHERE institution_id = $1 AND active = true
      `;
      const values = [institutionId];
      const result = await client.query(query, values);
      client.release();
      if (result.rows.length == 0) {
        return res.status(404).json({ message: "No active templates found" });
      }
      const templates = result.rows;
      res.json(templates);
    });
  } catch (error) {
    console.error("Error fetching templates:", error);
    res.status(500).json({ message: "An error occurred" });
  }
});

const downloadTemplate = asyncHandler(async (req, res) => {
  verifyToken(req, res, async () => {
    const institutionId = req.institutionId;
    const templateId = req.body.templateId;
    try {
      const client = await dbPool.connect();
      const query = `
        SELECT file_path AS filePath, file_name AS fileName FROM TEMPLATES_MASTER WHERE id = $1 AND institution_id = $2 AND active = true
      `;
      const values = [templateId, institutionId];
      const result = await client.query(query, values);

      if (result.rows.length === 0) {
        client.release();
        return res
          .status(404)
          .json({ message: "Template not found or not active" });
      }

      const template = result.rows[0];
      // console.log(template);
      const filePath = template.filepath;
      // console.log(filePath);
      const fileName = template.filename;
      // console.log(fileName);
      try {
        const response = await axios.get(filePath, {
          responseType: "arraybuffer",
        });
        res.setHeader("Content-Type", "application/octet-stream");
        res.setHeader(
          "Content-Disposition",
          `attachment; filename=${fileName}`
        );
        res.send(response.data);
      } catch (error) {
        // console.error("Error downloading template:", error);
        res
          .status(500)
          .json({ message: "An error occurred during the download" });
      }

      client.release();
    } catch (error) {
      // console.error("Error downloading template:", error);
      res.status(500).json({ message: "An error occurred" });
    }
  });
});

const uploadCertificateRequest = asyncHandler(async (req, res) => {
  verifyToken(req, res, async () => {
    upload(req, res, async (err) => {
      const file = req.file;
      if (err) {
        res.status(500).send("something went wrong");
      } else {
        try {
          const templateId = req.body.templateId;
          validateAndProcessFile(file, res);
          // const storeFileQuery = `
          //   INSERT INTO CERTIFICATE_REQUEST_FILES (file_format, file_size, received_time, file_path, file_name, md5sum, status, error_reason)
          //   VALUES ('Excel', $1, NOW(), $2, $3, md5($4), 0, null)
          // `;
          const storeFileValues = [
            file.size,
            file.path,
            file.filename,
            file.path,
          ];
          // const storeFileValues = [
          //   file.size,
          //   file.path,
          //   file.filename,
          //   calculateMd5(file.path),
          // ];

          // await dbPool.query(storeFileQuery, storeFileValues);

          // res.json({
          //   message: "File uploaded and records created successfully",
          // });
        } catch (error) {
          console.error("Error processing or storing file:", error);
          res.status(500).send("Error processing or storing file");
        }
      }
    });
  });
});

function calculateMd5(filePath) {
  const fileData = require("fs").readFileSync(filePath);
  const hash = crypto.createHash("md5");
  hash.update(fileData);
  return hash.digest("hex");
}

let rest = [];
let errorsRow=0
const validateAndProcessFile = (file, res) => {
  const rest = [];
  errorsRow=0
  const mf = [
    "FirstName",
    "College",
    "RegisterNo",
    "DateOfBirth",
    "Degree",
    "Specialization",
    "PassedOut",
  ];

  xlsxFile(file.path, { dateFormat: "dd/mm/yyyy" })
    .then((rows) => {
      const headCheck = mf.filter((n) => {
        return !rows[0].includes(n);
      });

      if (headCheck.length) {
        rest.push(
          `mandatory headers fields missing ${JSON.stringify(headCheck)}`
        );
      }

      if (!headCheck.length) {
        for (let i in rows) {
          for (let j in rows[i]) {
            if (rows[i][j] === null || rows[i][j] === "null") {
              rows[i].push(rows[0][j] + " " + "missing");
              errorsRow=errorsRow+1
            }
          }
        }
        rest.push(rows);
        if(errorsRow>0){
          rows[0].push("Error");
          if (rest.length) {
            res.status(406).send(rest);
          }
        }
        else{
          if (rest.length) {
            res.status(201).send(rest);
          }
        }
      }
    })
    .catch((error) => {
      rows[0].push("Error");
      console.error("Error processing file:", error);
      res.status(406).send(rest);
    });
};

module.exports = {
  getAllUser,
  institution,
  question,
  register,
  login,
  fotp,
  forP,
  getTemplates,
  downloadTemplate,
  uploadCertificateRequest,
};
