const Profile = require('../../models/Profile');
const User = require('../../models/User');
const { getProfile, updateProfile } = require('../../controllers/profileController');

jest.mock('../../models/Profile');
jest.mock('../../models/User');

describe('ProfileController - Unit Tests', () => {
  let req, res;

  beforeEach(() => {
    req = {
      user: {},
      body: {},
      params: {},
    };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };
    jest.clearAllMocks();
  });

  describe('getProfile', () => {
    it('should get user profile successfully', async () => {
      req.user = { id: 'user123' };

      const mockProfile = {
        userId: 'user123',
        fullName: 'Test User',
        points: 100,
        level: 2,
        achievements: [],
        populate: jest.fn().mockResolvedValue({
          userId: {
            email: 'test@example.com',
            username: 'testuser',
          },
          fullName: 'Test User',
          points: 100,
        }),
      };

      Profile.findOne.mockReturnValue(mockProfile);

      await getProfile(req, res);

      expect(Profile.findOne).toHaveBeenCalledWith({ userId: 'user123' });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: true,
        })
      );
    });

    it('should return 404 if profile not found', async () => {
      req.user = { id: 'user123' };

      Profile.findOne.mockReturnValue({
        populate: jest.fn().mockResolvedValue(null),
      });

      await getProfile(req, res);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: expect.stringContaining('не найден'),
        })
      );
    });
  });

  describe('updateProfile', () => {
    it('should update profile successfully', async () => {
      req.user = { id: 'user123' };
      req.body = {
        fullName: 'Updated Name',
        bio: 'New bio',
        location: 'Moscow',
      };

      const mockProfile = {
        userId: 'user123',
        fullName: 'Old Name',
        save: jest.fn().mockResolvedValue(true),
        populate: jest.fn().mockResolvedValue({
          fullName: 'Updated Name',
          bio: 'New bio',
          location: 'Moscow',
        }),
      };

      Profile.findOne.mockResolvedValue(mockProfile);

      await updateProfile(req, res);

      expect(mockProfile.fullName).toBe('Updated Name');
      expect(mockProfile.bio).toBe('New bio');
      expect(mockProfile.location).toBe('Moscow');
      expect(mockProfile.save).toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 if profile not found', async () => {
      req.user = { id: 'user123' };
      req.body = { fullName: 'Test' };

      Profile.findOne.mockResolvedValue(null);

      await updateProfile(req, res);

      expect(res.status).toHaveBeenCalledWith(404);
    });
  });
});

