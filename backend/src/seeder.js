const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');
const Category = require('./models/category');
const Course = require('./models/course');
const Video = require('./models/video');

// Connect to MongoDB
mongoose
  .connect('mongodb://localhost:27017/course_app', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Connected to MongoDB'))
  .catch((err) => console.error('Failed to connect to MongoDB:', err));

// Define paths
const basePath = path.join(__dirname, '../public/videos');
const thumbnailPath = path.join(__dirname, '../public/thumbnails');

const seedDatabase = async () => {
  try {
    // Clear existing data
    await Category.deleteMany();
    await Course.deleteMany();
    await Video.deleteMany();
    console.log('Existing data deleted.');

    // Seed category
    const category = await Category.create({
      name: 'Generative AI',
      description: 'Courses related to Generative AI and its applications.',
    });
    console.log('Category added.');

    // Read course folders
    const courseFolders = fs.readdirSync(basePath);

    for (const folder of courseFolders) {
      const courseFolderPath = path.join(basePath, folder);

      // Skip if not a directory
      if (!fs.lstatSync(courseFolderPath).isDirectory()) continue;

      // Attempt to read thumbnail as base64
      const thumbnailFile = path.join(thumbnailPath, `${folder}.jpg`);
      let imageBase64;
if (fs.existsSync(thumbnailFile)) {
  imageBase64 = fs.readFileSync(thumbnailFile, { encoding: 'base64' });
} else {
  const defaultThumbnailPath = path.join(thumbnailPath, 'image.png'); // Add a default image
  if (fs.existsSync(defaultThumbnailPath)) {
    imageBase64 = fs.readFileSync(defaultThumbnailPath, { encoding: 'base64' });
    console.warn(`Thumbnail not found for ${folder}. Using default thumbnail.`);
  } else {
    throw new Error(`Default thumbnail not found. Cannot continue without a thumbnail.`);
  }
}


      // Create a course
      const course = await Course.create({
        title: folder,
        description: `Learn about ${folder} in Generative AI.`,
        category: category._id,
        thumbnail: imageBase64, // Store base64 or null
      });
      console.log(`Course added: ${folder}`);

      // Read video files
      const videoFiles = fs.readdirSync(courseFolderPath);

      for (const videoFile of videoFiles) {
        const videoFilePath = path.join(courseFolderPath, videoFile);

        // Skip if not a file
        if (!fs.lstatSync(videoFilePath).isFile()) continue;

        await Video.create({
          title: path.parse(videoFile).name,
          description: `Learn about ${path.parse(videoFile).name} in ${folder}.`,
          videoUrl: `public/videos/${folder}/${videoFile}`,
          course: course._id,
        });
        console.log(`Video added: ${videoFile} under course: ${folder}`);
      }
    }

    mongoose.connection.close();
    console.log('Database seeding completed and connection closed.');
  } catch (error) {
    console.error('Error seeding the database:', error);
    mongoose.connection.close();
  }
};

seedDatabase();
