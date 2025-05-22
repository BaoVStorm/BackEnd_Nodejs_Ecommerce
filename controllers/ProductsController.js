import { getProductsByCategory, searchProducts} from "../models/Products.js";

export const getProductsByCategoryController = async(req, res) => {
    console.log("api get products by categories".red);

    try {
        const {category_id} = req.query; 

        if(!category_id)
            return res.status(400).json({msg:"CATEGORY not found"});

        const products = await getProductsByCategory(category_id);

        if (products.length === 0) {
            return res.status(404).json({msg: "No products found for this category"});
        }

        return res.status(200).json(products);
    } catch {
        return res.status(500).json({msg: "ERROR Server"})
    }
}

export const searchProductsController = async(req, res) => {

    try {
        const products = await searchProducts(req.query)

        if (products.length === 0) {
            return res.status(404).json({msg: "No products found for that params"});
        }

        return res.status(200).json(products);

    } catch {
        return res.status(500).json({msg: "ERROR Server"})
    }

}