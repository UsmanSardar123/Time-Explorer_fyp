// Wikimedia Commons thumbnail servers require a descriptive User-Agent.
// Without it requests may be throttled or rejected with HTTP 429.
const kWikimediaHeaders = <String, String>{
  'User-Agent': 'TimeExplorer/1.0 (Flutter; educational; contact@timeexplorer.app)',
};
