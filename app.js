require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const path = require('path');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Connect to MongoDB Atlas
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('Connected to MongoDB Atlas'))
.catch(err => console.error('Failed to connect to MongoDB', err));

// Define the Recipe schema and model
const recipeSchema = new mongoose.Schema({
  name: String,
  ingredients: [String],
});

const Recipe = mongoose.model('Recipe', recipeSchema);

// Serve the HTML form
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Route to handle recipe creation (from HTML form)
app.post('/recipes', async (req, res) => {
  try {
    const recipe = new Recipe({
      name: req.body.name,
      ingredients: req.body.ingredients.split(',').map(item => item.trim()),
    });
    await recipe.save();
    res.redirect('/');
  } catch (error) {
    res.status(400).send(error);
  }
});

// Route to fetch all recipes (for displaying in HTML)
app.get('/recipes', async (req, res) => {
  try {
    const recipes = await Recipe.find();
    res.json(recipes);
  } catch (error) {
    res.status(500).send(error);
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
