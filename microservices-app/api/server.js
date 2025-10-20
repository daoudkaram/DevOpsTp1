const express = require('express');
const { Client } = require('pg');
const redis = require('redis');

const app = express();
const PORT = 4000;

const dbClient = new Client({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'postgres',
  database: process.env.DB_NAME || 'microservices'
});

const redisClient = redis.createClient({
  socket: {
    host: process.env.REDIS_HOST || 'localhost',
    port: process.env.REDIS_PORT || 6379
  }
});

app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    service: 'api',
    timestamp: new Date().toISOString()
  });
});

app.get('/db-check', async (req, res) => {
  try {
    const result = await dbClient.query('SELECT NOW()');
    res.json({ 
      database: 'connected',
      time: result.rows[0].now
    });
  } catch (error) {
    res.status(500).json({ 
      database: 'error',
      message: error.message
    });
  }
});

app.post('/queue', async (req, res) => {
  try {
    const { task } = req.body;
    await redisClient.rPush('tasks', JSON.stringify({
      task,
      timestamp: new Date().toISOString()
    }));
    res.json({ 
      status: 'queued',
      task
    });
  } catch (error) {
    res.status(500).json({ 
      status: 'error',
      message: error.message
    });
  }
});

app.get('/queue', async (req, res) => {
  try {
    const length = await redisClient.lLen('tasks');
    res.json({ 
      queue_length: length,
      service: 'redis'
    });
  } catch (error) {
    res.status(500).json({ 
      status: 'error',
      message: error.message
    });
  }
});

async function init() {
  try {
    await dbClient.connect();
    console.log('Connected to PostgreSQL');
    
    await redisClient.connect();
    console.log('Connected to Redis');
    
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`API service running on port ${PORT}`);
    });
  } catch (error) {
    console.error('Initialization error:', error);
    process.exit(1);
  }
}

init();
