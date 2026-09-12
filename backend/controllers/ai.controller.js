var env = require('../config/env');
var GEMINI_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
var TIMEOUT_MS = 15000;

function ask(req, res, next) {
  var prompt = req.body.prompt;

  if (!prompt || typeof prompt !== 'string' || !prompt.trim()) {
    return res.status(400).json({ error: 'prompt is required and must be a non-empty string' });
  }

  if (!env.GEMINI_API_KEY) {
    return res.status(500).json({ error: 'AI service is not configured' });
  }

  var controller = new AbortController();
  var timeoutId = setTimeout(function() { controller.abort(); }, TIMEOUT_MS);

  fetch(GEMINI_URL + '?key=' + env.GEMINI_API_KEY, {
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

function storyboard(req, res, next) {
  var place = req.body;
  var required = ['placeId', 'name', 'category', 'description', 'location'];

  if (!place || typeof place !== 'object') {
    return res.status(400).json({ error: 'Place data is required' });
  }
  for (var i = 0; i < required.length; i++) {
    if (typeof place[required[i]] !== 'string' || !place[required[i]].trim()) {
      return res.status(400).json({ error: required[i] + ' is required' });
    }
  }
  if (!env.GEMINI_API_KEY) {
    return res.status(500).json({ error: 'AI service is not configured' });
  }

  var prompt = [
    'Create a short travel storyboard for a mobile travel app.',
    'Return valid JSON only. Do not use Markdown, code fences, or commentary.',
    'Use exactly this schema: {"title":"string","subtitle":"string","intro":"string","sections":[{"type":"string","title":"string","text":"string","items":["string"]}]}',
    'Return 4 to 6 sections. Use text for narrative sections and items for highlights.',
    'Adapt the content to the place type. Do not invent specific historical facts.',
    'Use general wording when the supplied information is insufficient.',
    'Keep every text value concise and useful on a phone.',
    'PLACE DATA:',
    JSON.stringify({
      placeId: place.placeId.trim(),
      name: place.name.trim(),
      category: place.category.trim(),
      description: place.description.trim(),
      location: place.location.trim(),
      history: typeof place.history === 'string' ? place.history.trim() : '',
      era: typeof place.era === 'string' ? place.era.trim() : '',
      facts: Array.isArray(place.facts) ? place.facts.slice(0, 5) : [],
    }),
  ].join('\n');

  var controller = new AbortController();
  var timeoutId = setTimeout(function() { controller.abort(); }, TIMEOUT_MS);

  fetch(GEMINI_URL + '?key=' + env.GEMINI_API_KEY, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ contents: [{ parts: [{ text: prompt }] }] }),
    signal: controller.signal,
  })
    .then(function(response) {
      clearTimeout(timeoutId);
      if (response.status === 429) {
        var rateError = new Error('AI service rate limit exceeded');
        rateError.status = 429;
        throw rateError;
      }
      if (!response.ok) {
        var serviceError = new Error('AI service request failed');
        serviceError.status = 502;
        throw serviceError;
      }
      return response.json();
    })
    .then(function(data) {
      var text = data.candidates && data.candidates[0] &&
        data.candidates[0].content && data.candidates[0].content.parts &&
        data.candidates[0].content.parts[0] && data.candidates[0].content.parts[0].text;
      var result = parseStoryboard(text);
      if (!result) return res.status(502).json({ error: 'AI service returned invalid storyboard JSON' });
      res.json({ storyboard: result });
    })
    .catch(function(err) {
      clearTimeout(timeoutId);
      if (err.name === 'AbortError') {
        return res.status(504).json({ error: 'AI service request timed out' });
      }
      if (err.status === 429 || err.status === 502) {
        return res.status(err.status).json({ error: err.message });
      }
      next(err);
    });
}

function parseStoryboard(text) {
  if (typeof text !== 'string' || !text.trim()) return null;
  var cleaned = text.trim().replace(/^```json\s*/i, '').replace(/^```\s*/i, '').replace(/\s*```$/i, '').trim();
  var value;
  try {
    value = JSON.parse(cleaned);
  } catch (_) {
    return null;
  }
  if (!value || typeof value !== 'object' || Array.isArray(value)) return null;
  if (!nonEmpty(value.title) || !nonEmpty(value.subtitle) || !nonEmpty(value.intro)) return null;
  if (!Array.isArray(value.sections) || value.sections.length < 4 || value.sections.length > 6) return null;
  for (var i = 0; i < value.sections.length; i++) {
    var section = value.sections[i];
    if (!section || typeof section !== 'object' || !nonEmpty(section.type) || !nonEmpty(section.title)) return null;
    var hasText = nonEmpty(section.text);
    var hasItems = Array.isArray(section.items) && section.items.length > 0 &&
      section.items.every(function(item) { return typeof item === 'string' && item.trim(); });
    if (!hasText && !hasItems) return null;
    if (hasText && typeof section.text !== 'string') return null;
  }
  return {
    title: value.title.trim(),
    subtitle: value.subtitle.trim(),
    intro: value.intro.trim(),
    sections: value.sections.map(function(section) {
      return {
        type: section.type.trim(),
        title: section.title.trim(),
        text: typeof section.text === 'string' ? section.text.trim() : '',
        items: Array.isArray(section.items) ? section.items.map(function(item) { return item.trim(); }) : [],
      };
    }),
  };
}

function nonEmpty(value) {
  return typeof value === 'string' && value.trim().length > 0;
}

module.exports = { ask: ask, storyboard: storyboard, parseStoryboard: parseStoryboard };
