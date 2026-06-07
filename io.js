var gameboy = null;
var gbRunInterval = null;
var settings = [false, true, false, 1, true, false, 8, 10, 20, false, false, false, false, true, [true, true, true, true]];

function cout(msg, level) {
  if (level < 2) console.log("[GB] " + msg);
  else console.warn("[GB] " + msg);
}

function findValue(key) { try { return localStorage.getItem(key); } catch(e) { return null; } }
function setValue(key, val) { try { localStorage.setItem(key, val); } catch(e) {} }
function deleteValue(key) { try { localStorage.removeItem(key); } catch(e) {} }

function arrayToBase64(arr) {
  var str = "";
  for (var i = 0; i < arr.length; i++) str += String.fromCharCode(arr[i]);
  return btoa(str);
}

function base64ToArray(str) {
  var raw = atob(str);
  var arr = [];
  for (var i = 0; i < raw.length; i++) arr.push(raw.charCodeAt(i) & 0xFF);
  return arr;
}

function to_byte(val) { return String.fromCharCode(val & 0xFF); }
function to_little_endian_dword(val) {
  return String.fromCharCode(val & 0xFF, (val >> 8) & 0xFF, (val >> 16) & 0xFF, (val >> 24) & 0xFF);
}

function GameBoyEmulatorInitialized() { return (typeof gameboy == "object" && gameboy != null); }
function GameBoyEmulatorPlaying() { return ((gameboy.stopEmulator & 2) == 0); }

function initNewCanvas() {
  if (GameBoyEmulatorInitialized()) {
    gameboy.canvas.width = 160;
    gameboy.canvas.height = 144;
  }
}

function initNewCanvasSize() {
  if (GameBoyEmulatorInitialized() && !settings[12]) {
    if (gameboy.onscreenWidth != 160 || gameboy.onscreenHeight != 144) {
      gameboy.initLCD();
    }
  }
}

function matchKey(key) {
  var keymap = ["right", "left", "up", "down", "a", "b", "select", "start"];
  return keymap.indexOf(key);
}

function GameBoyKeyDown(key) {
  if (GameBoyEmulatorInitialized() && GameBoyEmulatorPlaying()) {
    var idx = matchKey(key);
    if (idx >= 0) gameboy.JoyPadEvent(idx, true);
  }
}

function GameBoyKeyUp(key) {
  if (GameBoyEmulatorInitialized() && GameBoyEmulatorPlaying()) {
    var idx = matchKey(key);
    if (idx >= 0) gameboy.JoyPadEvent(idx, false);
  }
}

function GameBoyJoyPadEvent(keycode, down) {
  if (GameBoyEmulatorInitialized() && GameBoyEmulatorPlaying()) {
    if (keycode >= 0 && keycode < 8) gameboy.JoyPadEvent(keycode, down);
  }
}

function start(canvas, ROM) {
  clearLastEmulation();
  var romStr = "";
  for (var i = 0; i < ROM.length; i++) romStr += String.fromCharCode(ROM[i]);
  gameboy = new GameBoyCore(canvas, romStr);
  gameboy.openMBC = function() { return []; };
  gameboy.openRTC = function() { return []; };
  gameboy.start();
  run();
}

function run() {
  if (GameBoyEmulatorInitialized() && !GameBoyEmulatorPlaying()) {
    gameboy.stopEmulator &= 1;
    var dateObj = new Date();
    gameboy.firstIteration = dateObj.getTime();
    gameboy.iterations = 0;
    gbRunInterval = setInterval(function() {
      if (!document.hidden) gameboy.run();
    }, settings[6]);
  }
}

function pause() {
  if (GameBoyEmulatorInitialized() && GameBoyEmulatorPlaying()) {
    autoSave();
    clearLastEmulation();
  }
}

function clearLastEmulation() {
  if (GameBoyEmulatorInitialized() && GameBoyEmulatorPlaying()) {
    clearInterval(gbRunInterval);
    gameboy.stopEmulator |= 2;
  }
}

function autoSave() {}

function GameBoyGyroSignalHandler(e) {
  if (GameBoyEmulatorInitialized() && GameBoyEmulatorPlaying()) {
    if (e.gamma || e.beta) gameboy.GyroEvent(e.gamma * Math.PI / 180, e.beta * Math.PI / 180);
    else gameboy.GyroEvent(e.x, e.y);
    try { e.preventDefault(); } catch(e) {}
  }
}
