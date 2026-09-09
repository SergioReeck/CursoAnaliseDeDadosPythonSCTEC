SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM Product LEFT JOIN Category ON Product.CategoryId = Category.Id;