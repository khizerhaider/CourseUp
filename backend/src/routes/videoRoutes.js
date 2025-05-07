const express = require('express');
const Video = require('../models/video').default;

const router = express.Router();

// Get all videos
router.get('/', async (req, res) => {
  try {
    const videos = await Video.find();
    res.status(200).json(videos);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch videos' });
  }
});

// Get videos by category
router.get('/category/:category', async (req, res) => {
  try {
    const { category } = req.params;
    const videos = await Video.find({ category });
    res.status(200).json(videos);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch videos by category' });
  }
});

// Add a new video
router.post('/', async (req, res) => {
  try {
    const { title, thumbnail, category, description, videoUrl } = req.body;
    const newVideo = new Video({ title, thumbnail, category, description, videoUrl });
    await newVideo.save();
    res.status(201).json(newVideo);
  } catch (error) {
    res.status(500).json({ error: 'Failed to add video' });
  }
});

module.exports = router;