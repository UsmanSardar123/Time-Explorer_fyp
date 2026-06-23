function getHealth(req, res) {
  res.json({
    status: 'ok',
    service: 'Time Explorer API',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
  });
}

module.exports = { getHealth: getHealth };
