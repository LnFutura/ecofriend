const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../../server');
const User = require('../../models/User');
const Profile = require('../../models/Profile');

describe('Profile API - Integration Tests', () => {
  let token;
  let userId;

  beforeAll(async () => {
    const mongoUri = process.env.MONGO_URI || 'mongodb://localhost:27017/ecodrug_test';
    if (mongoose.connection.readyState === 0) {
      await mongoose.connect(mongoUri);
    }
  });

  beforeEach(async () => {
    await User.deleteMany({});
    await Profile.deleteMany({});

    // Create test user and get token
    const response = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'profileuser@test.com',
        username: 'profileuser',
        password: 'password123',
      });

    token = response.body.token;
    userId = response.body.user._id;
  });

  afterAll(async () => {
    await User.deleteMany({});
    await Profile.deleteMany({});
    await mongoose.connection.close();
  });

  describe('GET /api/profile', () => {
    it('should get user profile', async () => {
      const response = await request(app)
        .get('/api/profile')
        .set('Authorization', `Bearer ${token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveProperty('userId');
      expect(response.body.data).toHaveProperty('points', 0);
      expect(response.body.data).toHaveProperty('level', 1);
    });

    it('should not get profile without authentication', async () => {
      const response = await request(app)
        .get('/api/profile');

      expect(response.status).toBe(401);
    });
  });

  describe('PUT /api/profile', () => {
    it('should update user profile', async () => {
      const updateData = {
        fullName: 'John Doe',
        bio: 'Eco enthusiast',
        location: 'Moscow, Russia',
        phone: '+7 900 123-45-67',
      };

      const response = await request(app)
        .put('/api/profile')
        .set('Authorization', `Bearer ${token}`)
        .send(updateData);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveProperty('fullName', 'John Doe');
      expect(response.body.data).toHaveProperty('bio', 'Eco enthusiast');
      expect(response.body.data).toHaveProperty('location', 'Moscow, Russia');
    });

    it('should not update profile without authentication', async () => {
      const response = await request(app)
        .put('/api/profile')
        .send({ fullName: 'Test' });

      expect(response.status).toBe(401);
    });

    it('should update only provided fields', async () => {
      // First update
      await request(app)
        .put('/api/profile')
        .set('Authorization', `Bearer ${token}`)
        .send({
          fullName: 'John Doe',
          bio: 'Original bio',
        });

      // Second update (only bio)
      const response = await request(app)
        .put('/api/profile')
        .set('Authorization', `Bearer ${token}`)
        .send({
          bio: 'Updated bio',
        });

      expect(response.status).toBe(200);
      expect(response.body.data).toHaveProperty('fullName', 'John Doe'); // unchanged
      expect(response.body.data).toHaveProperty('bio', 'Updated bio'); // updated
    });
  });

  describe('GET /api/profile/achievements', () => {
    it('should get user achievements', async () => {
      const response = await request(app)
        .get('/api/profile/achievements')
        .set('Authorization', `Bearer ${token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });

  describe('GET /api/profile/completed-courses', () => {
    it('should get user completed courses', async () => {
      const response = await request(app)
        .get('/api/profile/completed-courses')
        .set('Authorization', `Bearer ${token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });
});

