const express = require("express");
const userRoute = express.Router();
const {
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
} = require("../controllers/userController");

userRoute.route("/").get(getAllUser);

userRoute.route("/api/institution-details").get(institution);

userRoute.route("/api/secret-questions").get(question);

userRoute.route("/api/register").post(register);

userRoute.route("/api/login").post(login);

userRoute.route("/api/fotp").post(fotp);

userRoute.route("/api/forP").post(forP);

userRoute.route("/api/templates").get(getTemplates);

userRoute.route("/api/download-template").post(downloadTemplate);

userRoute.route("/api/uploadCertificateRequest").post(uploadCertificateRequest);

module.exports = userRoute;
