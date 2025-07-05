
const express = require('express');
const mongoose = require('mongoose');
const axios = require('axios');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('MongoDB connection error:', err));

// User Schema
const userSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  name: String,
  age: String,
  email: String,
  bio: String,
  phone: String,
  occupation: String,
  interests: String,
  preferences: {
    cleanliness: Number,
    socialStyle: Number,
    noiseLevel: Number,
    petsAllowed: Boolean,
    smokingAllowed: Boolean,
    sleepSchedule: String,
    budget: String,
    moveInDate: String,
    dealBreakers: [String],
  },
  verificationStatus: { type: String, enum: ['Verified', 'Pending', 'Unverified'] },
  location: String,
  profileImageUrl: String,
});
const User = mongoose.model('User', userSchema);

// Room Schema
const roomSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  title: String,
  description: String,
  rent: Number,
  location: String,
  dimensions: {
    length: Number,
    width: Number,
    height: Number,
  },
  amenities: [String],
  images: [String],
  noiseLevel: Number,
  lightLevel: Number,
  ownerId: String,
  isAvailable: Boolean,
  createdAt: Date,
});
const Room = mongoose.model('Room', roomSchema);

// Match Schema
const matchSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  userId: String,
  roomId: String,
  compatibilityScore: Number,
  scoreBreakdown: { type: Map, of: Number },
  matchReasons: [String],
  potentialIssues: [String],
  matchedAt: Date,
});
const Match = mongoose.model('Match', matchSchema);

// Chat Schema
const chatSchema = new mongoose.Schema({
  matchId: String,
  messages: [{
    senderId: String,
    content: String,
    timestamp: Date,
  }],
});
const Chat = mongoose.model('Chat', chatSchema);

// API Endpoints

// Onboarding: Extract preferences using LLM
app.post('/api/onboarding', async (req, res) => {
  const { userId, conversation } = req.body;
  try {
    const mockResponse = {
      preferences: {
        cleanliness: 4,
        socialStyle: 3,
        noiseLevel: 2,
        petsAllowed: true,
        smokingAllowed: false,
        sleepSchedule: 'Night Owl',
        budget: '$1000-$1500',
        moveInDate: '2025-08-01',
        dealBreakers: ['Smoking'],
      },
    };
    const preferences = mockResponse.preferences;
    const user = await User.findOneAndUpdate(
      { id: userId },
      { preferences, verificationStatus: 'Pending' },
      { new: true, upsert: true }
    );
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Rooms: Create sensor-verified listing
app.post('/api/rooms', async (req, res) => {
  const roomData = req.body;
  try {
    const room = new Room({
      ...roomData,
      id: Date.now().toString(),
      createdAt: new Date(),
    });
    await room.save();
    res.json(room);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Matches: Semantic preference matching
app.post('/api/matches', async (req, res) => {
  const { userId } = req.body;
  try {
    const user = await User.findOne({ id: userId });
    const rooms = await Room.find({ isAvailable: true });
    const matches = [];
    for (const room of rooms) {
      const mockResponse = {
        score: 0.85,
        scoreBreakdown: { lifestyle: 0.8, cleanliness: 0.9, budget: 0.85 },
        matchReasons: ['Similar lifestyle', 'Budget match'],
        potentialIssues: ['Different sleep schedules'],
      };
      const matchData = mockResponse;
      const match = new Match({
        id: `${userId}-${room.id}`,
        userId,
        roomId: room.id,
        compatibilityScore: matchData.score,
        scoreBreakdown: matchData.scoreBreakdown,
        matchReasons: matchData.matchReasons,
        potentialIssues: matchData.potentialIssues,
        matchedAt: new Date(),
      });
      await match.save();
      matches.push({ ...match.toObject(), user, room });
    }
    res.json(matches);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Agreements: Generate AI-drafted roommate agreement
app.post('/api/agreements', async (req, res) => {
  const { userId, roomId } = req.body;
  try {
    const mockResponse = {
      agreement: 'Roommate Agreement:\n1. Noise: Keep noise below 40 dB after 10 PM.\n2. Cleanliness: Shared spaces cleaned weekly.\n3. Pets: Allowed with prior approval.\n4. Rent: $1200 due on 1st of each month.',
    };
    res.json({ agreement: mockResponse.agreement });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Mediation: Analyze chat sentiment
app.post('/api/mediation', async (req, res) => {
  const { matchId, chatHistory } = req.body;
  try {
    const mockResponse = {
      suggestions: ['Schedule a meeting to discuss noise concerns.', 'Agree on a cleaning schedule.'],
    };
    const chat = new Chat({
      matchId,
      messages: chatHistory.map(msg => ({ ...msg, timestamp: new Date() })),
    });
    await chat.save();
    res.json({ suggestions: mockResponse.suggestions });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
