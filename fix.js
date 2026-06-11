const fs = require('fs');
const path = require('path');

const dir = 'd:\\Custom Framing  Art Conservation Studio';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.html'));

for (const file of files) {
    const filePath = path.join(dir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Replace all variations of mojibake dashes and bullets
    content = content.replace(/Ã¢â‚¬â€œ/g, '-');
    content = content.replace(/Ã¢â‚¬â€ /g, '-');
    content = content.replace(/â€"/g, '-'); // another variant
    content = content.replace(/â€“/g, '-');
    content = content.replace(/â€”/g, '-');
    content = content.replace(/â€¢/g, '•');

    fs.writeFileSync(filePath, content, 'utf8');
}

console.log("Successfully cleaned up mojibake using Node.");
