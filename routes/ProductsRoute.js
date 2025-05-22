import express from 'express';
import {getProductsByCategoryController, searchProductsController} from '../controllers/ProductsController.js';

const router = express.Router();

router.get("/category", getProductsByCategoryController);

router.get("/search", searchProductsController);

export default router;