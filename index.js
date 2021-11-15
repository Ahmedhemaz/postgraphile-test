import express, { urlencoded } from "express";
import postgraphile from "./postgraphile.config.js.example";

const app = express();
const port = 3000;
app.use(express.json());

app.use(postgraphile);
app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
