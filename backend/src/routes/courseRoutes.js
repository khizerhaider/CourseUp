const express = require('express');
const mongoose = require('mongoose');
const Course = require('../models/course');

const router = express.Router();

router.get('/', async (req, res) => {
    try {
      const coursesWithVideos = await Course.aggregate([
        {
          $lookup: {
            from: 'videos',
            localField: '_id',
            foreignField: 'course',
            as: 'videos',
          },
        },
        {
          $lookup: {
            from: 'categories',
            localField: 'category',
            foreignField: '_id',
            as: 'category',
          },
        },
        {
          $unwind: '$category',
        },
      ]);
  
      res.status(200).json(coursesWithVideos);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Failed to fetch courses with videos' });
    }
  });
  router.get('/:title', async (req, res) => {
    try {
      const { title } = req.params;
      const courseWithVideos = await Course.aggregate([
        {
          $match: { title: title },
        },
        {
          $lookup: {
            from: 'videos',
            localField: '_id',
            foreignField: 'course',
            as: 'videos',
          },
        },
      ]);
  
      if (courseWithVideos.length === 0) {
        return res.status(404).json({ error: 'Course not found' });
      }
  
      res.status(200).json(courseWithVideos[0]);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Failed to fetch course details' });
    }
  });

module.exports = router;

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