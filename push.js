const fs = require('fs');

async function updateFile(path, repo, owner, token) {
  console.log(`Fetching SHA for ${path}...`);
  const getRes = await fetch(`https://api.github.com/repos/${owner}/${repo}/contents/${path}`, {
    headers: { 
      'Authorization': `Bearer ${token}`,
      'User-Agent': 'Node.js'
    }
  });
  const getJson = await getRes.json();
  let sha = getJson.sha;

  console.log(`Uploading ${path}...`);
  const content = fs.readFileSync(path, 'utf8');
  const base64Content = Buffer.from(content).toString('base64');
  
  const putRes = await fetch(`https://api.github.com/repos/${owner}/${repo}/contents/${path}`, {
    method: 'PUT',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
      'User-Agent': 'Node.js'
    },
    body: JSON.stringify({
      message: `Refactor UI to pure Material 3 design - ${path}`,
      content: base64Content,
      sha: sha
    })
  });
  
  if (putRes.ok) {
    console.log(`✅ Successfully updated ${path}`);
  } else {
    console.error(`❌ Failed to update ${path}:`, putRes.status, await putRes.text());
  }
}

async function main() {
  const token = process.env.GITHUB_TOKEN;
  if (!token) {
    console.error("No GITHUB_TOKEN found!");
    process.exit(1);
  }
  const owner = 'Coucou1818';
  const repo = 'superhut';
  const files = [
    'pubspec.yaml',
    'lib/main.dart',
    'lib/home/homeview/view.dart',
    'lib/home/Functionpage/view.dart',
    'lib/home/userpage/view.dart'
  ];
  
  for (const file of files) {
    try {
      await updateFile(file, repo, owner, token);
    } catch (e) {
      console.error(`Error processing ${file}:`, e);
    }
  }
}

main();
