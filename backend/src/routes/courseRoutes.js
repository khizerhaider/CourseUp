const express = require('express');
const mongoose = require('mongoose');
const Course = require('../models/course');
const Video = require('../models/video');
const Category = require('../models/category');
const fs = require('fs');
const path = require('path');
const mime = require('mime'); // install this with: npm install mime

const router = express.Router();

// Utility: Convert title to slug
const slugify = (text) =>
  text
    .toString()
    .toLowerCase()
    .trim()
    .replace(/[^\w\s-]/g, '')
    .replace(/\s+/g, '-')
    .replace(/--+/g, '-');

// Utility: Convert image file to base64

const encodeImageToBase64 = (filePath) => {
  try {
    const absolutePath = path.resolve(filePath);
    console.log('Absolute path:');
    //const imageBuffer = fs.readFileSync(absolutePath);
    const mimeType = mime.getType(absolutePath); // e.g., 'image/png'

    return `data:${mimeType};base64,${absolutePath}`;
  } catch (err) {
    //console.error('Error reading image:', filePath, err.message);
    return '';
  }
};
// Route: Get all courses (with base64 thumbnail, category name, and slug)
router.get('/', async (req, res) => {
  try {
    const courses = await Course.find().populate('category').lean();
    const courseIds = courses.map(c => c._id);
    const videos = await Video.find({ course: { $in: courseIds } }).lean();

    const result = courses.map(course => {
      const courseVideos = videos.filter(v => v.course.toString() === course._id.toString());
      return {
        _id: course._id,
        title: course.title,
        description: course.description,
        category: course.category?.name || 'Uncategorized',
        slug: slugify(course.title),
        thumbnail: course.thumbnail,
        videos: courseVideos.map(v => ({
          title: v.title,
          videoUrl: v.videoUrl,
        })),
      };
    });

    res.status(200).json(result);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch courses' });
  }
});

// Route: Get course details by slug
router.get('/:slug', async (req, res) => {
  try {
    const { slug } = req.params;
    console.log('Slug:', slug);
    const courses = await Course.find().lean();
    const matched = courses.find(c => slugify(c.title) === slug);

    if (!matched) {
      return res.status(404).json({ error: 'Course not found' });
    }

    const base64Thumbnail = matched.thumbnail;

    res.status(200).json({
      title: matched.title,
      description: matched.description,
      thumbnail: base64Thumbnail,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch course details' });
  }
});

// Route: Get videos for a course by slug
router.get('/:slug/videos', async (req, res) => {
  try {
    const { slug } = req.params;

    const courses = await Course.find().lean();
    const matched = courses.find(c => slugify(c.title) === slug);

    if (!matched) {
      return res.status(404).json({ error: 'Course not found' });
    }

    const videos = await Video.find({ course: matched._id }).lean();
    const simplified = videos.map(v => ({
      title: v.title,
      videoUrl: v.videoUrl,
      description: v.description,
    }));
    console.log('Videos:', simplified);
    res.status(200).json(simplified);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch course videos' });
  }
});

module.exports = router;


  // router.get('/:title', async (req, res) => {
  //   try {
  //     const { title } = req.params;
  //     const courseWithVideos = await Course.aggregate([
  //       {
  //         $match: { title: title },
  //       },
  //       {
  //         $lookup: {
  //           from: 'videos',
  //           localField: '_id',
  //           foreignField: 'course',
  //           as: 'videos',
  //         },
  //       },
  //     ]);
  
  //     if (courseWithVideos.length === 0) {
  //       return res.status(404).json({ error: 'Course not found' });
  //     }
  
  //     res.status(200).json(courseWithVideos[0]);
  //   } catch (error) {
  //     console.error(error);
  //     res.status(500).json({ error: 'Failed to fetch course details' });
  //   }
  // });

// const express = require('express');
// const Course = require('../models/course');

// const router = express.Router();

// // Get all courses
// router.get('/', async (req, res) => {
//   try {
//     const courses = await Course.find().populate('category');
//     res.status(200).json(courses);
//   } catch (error) {
//     res.status(500).json({ error: 'Failed to fetch courses' });
//   }
// });

// module.exports = router;