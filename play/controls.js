const JS_KEY_UP = 38;
const JS_KEY_LEFT = 37;
const JS_KEY_RIGHT = 39;
const JS_KEY_DOWN = 40;
const JS_KEY_ENTER = 13;
const JS_KEY_ALT = 18;
const JS_KEY_CTRL = 17;
const JS_KEY_SHIFT = 16;
const JS_KEY_W = 87;
const JS_KEY_A = 65;
const JS_KEY_S = 83;
const JS_KEY_D = 68;
const JS_KEY_J = 74;
const JS_KEY_K = 75;
const JS_KEY_Z = 90;
const JS_KEY_X = 88;
const DEADZONE = 0.1;

var isTouchEnabled = "ontouchstart" in document.documentElement;
var controller = document.getElementById("controller");

function bindButton(el, code) {
  el.addEventListener("touchstart", function(e) {
    e.preventDefault(); e.stopPropagation();
    el.classList.add("btnPressed");
    GameBoyKeyDown(code);
  });
  el.addEventListener("touchend", function(e) {
    e.preventDefault(); e.stopPropagation();
    el.classList.remove("btnPressed");
    GameBoyKeyUp(code);
  });
}

function bindDpad(el) {
  var activeKeys = {};
  el.addEventListener("touchstart", function(e) {
    e.preventDefault(); e.stopPropagation();
    move(e);
  });
  el.addEventListener("touchmove", function(e) {
    e.preventDefault(); e.stopPropagation();
    move(e);
  });
  el.addEventListener("touchend", function(e) {
    e.preventDefault(); e.stopPropagation();
    ["left", "right", "up", "down"].forEach(function(k) {
      if (activeKeys[k]) { GameBoyKeyUp(k); activeKeys[k] = false; }
    });
  });

  function move(e) {
    var rect = el.getBoundingClientRect();
    var t = e.targetTouches[0];
    if (!t) return;
    var x = (2 * (t.clientX - rect.left)) / rect.width - 1;
    var y = (2 * (t.clientY - rect.top)) / rect.height - 1;

    var left = x < -DEADZONE && y > x && y < -x;
    var right = x > DEADZONE && y > -x && y < x;
    var up = y < -DEADZONE && x > y && x < -y;
    var down = y > DEADZONE && x > -y && x < y;

    if (!left && activeKeys.left) { GameBoyKeyUp("left"); activeKeys.left = false; }
    if (!right && activeKeys.right) { GameBoyKeyUp("right"); activeKeys.right = false; }
    if (!up && activeKeys.up) { GameBoyKeyUp("up"); activeKeys.up = false; }
    if (!down && activeKeys.down) { GameBoyKeyUp("down"); activeKeys.down = false; }

    if (left && !activeKeys.left) { GameBoyKeyDown("left"); activeKeys.left = true; }
    if (right && !activeKeys.right) { GameBoyKeyDown("right"); activeKeys.right = true; }
    if (up && !activeKeys.up) { GameBoyKeyDown("up"); activeKeys.up = true; }
    if (down && !activeKeys.down) { GameBoyKeyDown("down"); activeKeys.down = true; }
  }
}

if (isTouchEnabled) {
  bindButton(document.getElementById("controller_a"), "a");
  bindButton(document.getElementById("controller_b"), "b");
  bindButton(document.getElementById("controller_start"), "start");
  bindButton(document.getElementById("controller_select"), "select");
  bindDpad(document.getElementById("controller_dpad"));
  controller.style.display = "";
}

document.addEventListener("keydown", function(e) {
  if (e.altKey || e.ctrlKey || e.metaKey) return;
  var handled = true;
  switch (e.keyCode) {
    case JS_KEY_LEFT: case JS_KEY_A: GameBoyKeyDown("left"); break;
    case JS_KEY_RIGHT: case JS_KEY_D: GameBoyKeyDown("right"); break;
    case JS_KEY_UP: case JS_KEY_W: GameBoyKeyDown("up"); break;
    case JS_KEY_DOWN: case JS_KEY_S: GameBoyKeyDown("down"); break;
    case JS_KEY_ENTER: GameBoyKeyDown("start"); break;
    case JS_KEY_ALT: case JS_KEY_Z: case JS_KEY_J: GameBoyKeyDown("a"); break;
    case JS_KEY_CTRL: case JS_KEY_K: case JS_KEY_X: GameBoyKeyDown("b"); break;
    case JS_KEY_SHIFT: GameBoyKeyDown("select"); break;
    default: handled = false;
  }
  if (handled) e.preventDefault();
});

document.addEventListener("keyup", function(e) {
  var handled = true;
  switch (e.keyCode) {
    case JS_KEY_LEFT: case JS_KEY_A: GameBoyKeyUp("left"); break;
    case JS_KEY_RIGHT: case JS_KEY_D: GameBoyKeyUp("right"); break;
    case JS_KEY_UP: case JS_KEY_W: GameBoyKeyUp("up"); break;
    case JS_KEY_DOWN: case JS_KEY_S: GameBoyKeyUp("down"); break;
    case JS_KEY_ENTER: GameBoyKeyUp("start"); break;
    case JS_KEY_ALT: case JS_KEY_Z: case JS_KEY_J: GameBoyKeyUp("a"); break;
    case JS_KEY_CTRL: case JS_KEY_K: case JS_KEY_X: GameBoyKeyUp("b"); break;
    case JS_KEY_SHIFT: GameBoyKeyUp("select"); break;
    default: handled = false;
  }
  if (handled) e.preventDefault();
});
