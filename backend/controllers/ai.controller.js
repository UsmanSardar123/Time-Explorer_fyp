var GEMINI_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
var TIMEOUT_MS = 15000;

function ask(req, res, next) {
  var prompt = req.body.prompt;

  if (!prompt || typeof prompt !== 'string' || !prompt.trim()) {
    return res.status(400).json({ error: 'prompt is required and must be a non-empty string' });
  }

  if (!process.env.GEMINI_API_KEY) {
    return res.status(500).json({ error: 'AI service is not configured' });
  }

  var controller = new AbortController();
  var timeoutId = setTimeout(function() { controller.abort(); }, TIMEOUT_MS);

  fetch(GEMINI_URL + '?key=' + process.env.GEMINI_API_KEY, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ contents: [{ parts: [{ text: prompt.trim() }] }] }),
    signal: controller.signal,
  })
    .then(function(response) {
      clearTimeout(timeoutId);
      if (!response.ok) {
        var err = new Error('AI service request failed');
        err.status = 502;
        throw err;
      }
      return response.json();
    })
    .then(function(data) {
      var text = data.candidates &&
        data.candidates[0] &&
        data.candidates[0].content &&
        data.candidates[0].content.parts &&
        data.candidates[0].content.parts[0] &&
        data.candidates[0].content.parts[0].text;

      if (!text) {
        return res.status(502).json({ error: 'AI service returned no content' });
      }
      res.json({ response: text });
    })
    .catch(function(err) {
      clearTimeout(timeoutId);
      if (err.name === 'AbortError') {
        return res.status(504).json({ error: 'AI service request timed out' });
      }
      if (err.status === 502) {
        return res.status(502).json({ error: err.message });
      }
      next(err);
    });
}

module.exports = { ask: ask };
