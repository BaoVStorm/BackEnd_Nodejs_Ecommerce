import express from 'express';
import color from 'colors';
import dotenv from 'dotenv';
import morgan from 'morgan';

import CategoriesRoute from "./routes/CategoriesRoute.js";
import ProductsRoute from "./routes/ProductsRoute.js";
import OrderRoute from './routes/OrderRoute.js';

// express
const app = express();
    // luôn luôn nên thêm
app.use(express.json());
app.use(express.urlencoded({extended: true}))       // dữ liệu sẽ lồng nhau ví dụ user[name] và user[age]

// dotenv
dotenv.config({path: "./config/.env"});
const PORT = process.env.PORT || 3000;

// morgan
app.use(morgan('dev'));

// // middleware ran
// app.use((req, res, next) => {
//     console.log("middleware ran");
//     req.title = "test use";
//     next(); 
// })

app.use("/api/categories", CategoriesRoute);
app.use("/api/products", ProductsRoute);
app.use("/api/orders", OrderRoute);

app.listen(PORT, 
    console.log(`Server running on port: ${PORT}`.blue.underline.bold)
)