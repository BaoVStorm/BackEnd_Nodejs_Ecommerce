import {getAllCategories} from '../models/Categories.js';

export const getAllCategoriesController = async(req, res) => {
    console.log("api get all categories".red);

    try {
        const categories = await getAllCategories();

        res.status(200).json(categories);
    } catch(error) {
        res.status(500).json({msg: "ERROR Server"})
    }
}
