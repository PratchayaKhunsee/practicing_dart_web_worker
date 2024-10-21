var i = 0;
var id;
id = setInterval(() => { const d = i++; postMessage(65 + d); setTimeout(() => postMessage(97 + d), 500); if (i >= 26) { clearInterval(id); }; }, 1000);