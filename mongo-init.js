// Initialize MongoDB database
db = db.getSiblingDB('ecodrug');

// Create collections with validation (optional)
db.createCollection('users');
db.createCollection('profiles');

// Create indexes for better performance
db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ username: 1 }, { unique: true });
db.profiles.createIndex({ user: 1 }, { unique: true });
db.profiles.createIndex({ points: -1 });
db.profiles.createIndex({ level: -1 });

print('MongoDB initialized successfully for EcoDrug');

