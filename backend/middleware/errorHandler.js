function errorHandler(err, req, res, _next) {
  var status = err.status || 500;

  if (process.env.NODE_ENV !== 'production') {
    console.error('[Error]', err.stack);
  } else {
    console.error('[Error]', { status: status, method: req.method, url: req.url, message: err.message });
  }

  // Never expose internal error details to clients in production
  var message = (process.env.NODE_ENV === 'production' && status === 500)
    ? 'Internal Server Error'
    : (err.message || 'Internal Server Error');

  res.status(status).json({ error: message, code: status });
}

module.exports = errorHandler;
