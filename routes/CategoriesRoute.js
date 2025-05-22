import express from 'express';
import {getAllCategoriesController} from '../controllers/CategoriesControlller.js';

const router = express.Router();

router.get('/getAllCategories', getAllCategoriesController);

export default router ;