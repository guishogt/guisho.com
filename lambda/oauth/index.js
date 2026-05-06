const https = require('https');
const querystring = require('querystring');

const CLIENT_ID = process.env.GITHUB_CLIENT_ID;
const CLIENT_SECRET = process.env.GITHUB_CLIENT_SECRET;
const REDIRECT_URI = process.env.REDIRECT_URI || 'https://guisho.com/api/auth/callback';

// Only these GitHub users can access the admin
const ALLOWED_USERS = ['guishogt'];

exports.handler = async (event) => {
  const path = event.rawPath || event.path || '';

  // CORS headers
  const headers = {
    'Access-Control-Allow-Origin': 'https://guisho.com',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  };

  if (event.requestContext?.http?.method === 'OPTIONS') {
    return { statusCode: 200, headers, body: '' };
  }

  // Auth endpoint - redirect to GitHub
  if (path.endsWith('/auth') || path.endsWith('/auth/')) {
    const authUrl = `https://github.com/login/oauth/authorize?client_id=${CLIENT_ID}&redirect_uri=${encodeURIComponent(REDIRECT_URI)}&scope=repo,user`;
    return {
      statusCode: 302,
      headers: { ...headers, Location: authUrl },
      body: '',
    };
  }

  // Callback endpoint - exchange code for token
  if (path.includes('/callback')) {
    const params = event.queryStringParameters || {};
    const code = params.code;

    if (!code) {
      return {
        statusCode: 400,
        headers,
        body: JSON.stringify({ error: 'Missing code parameter' }),
      };
    }

    try {
      const tokenData = await exchangeCodeForToken(code);

      // Check if GitHub returned an error
      if (tokenData.error) {
        console.error('GitHub OAuth error:', tokenData);
        const errorMsg = encodeURIComponent(tokenData.error_description || tokenData.error);
        return {
          statusCode: 302,
          headers: {
            ...headers,
            Location: `https://guisho.com/admin/callback.html#error=${encodeURIComponent(tokenData.error)}&error_description=${errorMsg}`,
          },
          body: '',
        };
      }

      // Verify the user is allowed
      const userInfo = await getGitHubUser(tokenData.access_token);
      if (!ALLOWED_USERS.includes(userInfo.login)) {
        console.log(`Access denied for user: ${userInfo.login}`);
        return {
          statusCode: 302,
          headers: {
            ...headers,
            Location: `https://guisho.com/admin/callback.html#error=access_denied&error_description=${encodeURIComponent('You are not authorized to access this site.')}`,
          },
          body: '',
        };
      }

      // Redirect to static callback page with token in hash (not logged/cached)
      return {
        statusCode: 302,
        headers: {
          ...headers,
          Location: `https://guisho.com/admin/callback.html#token=${tokenData.access_token}`,
        },
        body: '',
      };
    } catch (error) {
      console.error('Token exchange error:', error);
      return {
        statusCode: 302,
        headers: {
          ...headers,
          Location: `https://guisho.com/admin/callback.html#error=token_exchange_failed&error_description=${encodeURIComponent('Token exchange failed. Please try again.')}`,
        },
        body: '',
      };
    }
  }

  return {
    statusCode: 404,
    headers,
    body: JSON.stringify({ error: 'Not found' }),
  };
};

function getGitHubUser(token) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'api.github.com',
      path: '/user',
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
        'User-Agent': 'guisho-cms',
      },
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        try {
          resolve(JSON.parse(data));
        } catch (e) {
          reject(new Error('Failed to parse user response'));
        }
      });
    });

    req.on('error', reject);
    req.end();
  });
}

function exchangeCodeForToken(code) {
  return new Promise((resolve, reject) => {
    const postData = querystring.stringify({
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      code: code,
    });

    const options = {
      hostname: 'github.com',
      path: '/login/oauth/access_token',
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Content-Length': Buffer.byteLength(postData),
      },
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        try {
          resolve(JSON.parse(data));
        } catch (e) {
          reject(new Error('Failed to parse response'));
        }
      });
    });

    req.on('error', reject);
    req.write(postData);
    req.end();
  });
}
