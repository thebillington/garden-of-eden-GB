let HORIZONTALDATATILES = 12;
let VERTICALDATATILES = 30;

let tiledataArray = [];
for (var i = 0; i < HORIZONTALDATATILES; i++) {
    let verticalTiles = [];
    for (var j = 0; j < VERTICALDATATILES; j++) {
        let verticalPixels = [];
        for (var k = 0; k < 8; k++) {
            verticalPixels.push([3,3,3,3,3,3,3,3]);
        }
        verticalTiles.push(verticalPixels);
    }
    tiledataArray.push(verticalTiles);
}

let SELECTEDDATATILE;
let SELECTEDDATATILEDATA;
let SELECTEDMAPTILE;

let colours = ["black", "darkgrey", "lightgrey", "white"];

var tiledata = function(sketch) {

    let TILEDATACANVASWIDTH;
    let TILEDATACANVASHEIGHT;
    let TILEDATAWIDTH;
    let TILEDATAHEIGHT;
    let TILEDATAPIXELWIDTH;
    let TILEDATAPIXELHEIGHT;

    sketch.setup = function() {
        let parent = document.getElementById("tiledata");
        TILEDATACANVASWIDTH = parent.offsetWidth;
        TILEDATACANVASHEIGHT = parent.offsetHeight;
        TILEDATAWIDTH = TILEDATACANVASWIDTH / HORIZONTALDATATILES;
        TILEDATAHEIGHT = TILEDATACANVASHEIGHT / VERTICALDATATILES;
        TILEDATAPIXELWIDTH = TILEDATAWIDTH / 8;
        TILEDATAPIXELHEIGHT = TILEDATAHEIGHT / 8;
        let tiledataCanvas = sketch.createCanvas(TILEDATACANVASWIDTH, TILEDATACANVASHEIGHT);
        tiledataCanvas.parent("tiledata");
        tiledataCanvas.mousePressed(mouseClick);
    }

    sketch.draw = function() {
        for (var x = 0; x < tiledataArray.length; x++) {
            for (var y = 0; y < tiledataArray[x].length; y++) {
                let TILEX = x * TILEDATAWIDTH;
                let TILEY = y * TILEDATAHEIGHT;
                if (SELECTEDDATATILE && x == SELECTEDDATATILE.x && y == SELECTEDDATATILE.y) {
                    sketch.fill("purple");
                    sketch.rect(TILEX - 1, TILEY - 1, TILEDATAWIDTH, TILEDATAHEIGHT);
                    continue;
                }
                sketch.strokeWeight(2);
                sketch.rect(TILEX - 1, TILEY - 1, TILEDATAWIDTH, TILEDATAHEIGHT);
                for (var pixelY = 0; pixelY < tiledataArray[x][y].length; pixelY++) {
                    for (var pixelX = 0; pixelX < tiledataArray[x][y][pixelY].length; pixelX++) {
                        sketch.fill(colours[tiledataArray[x][y][pixelY][pixelX]]);
                        sketch.strokeWeight(1);
                        sketch.rect(TILEX + (pixelX * TILEDATAPIXELWIDTH), TILEY + (pixelY * TILEDATAPIXELHEIGHT), TILEDATAPIXELWIDTH, TILEDATAPIXELHEIGHT);
                    }
                }
            }
        }
    }

    function mouseClick() {
        let xTilePos = parseInt(sketch.mouseX / TILEDATAWIDTH);
        let yTilePos = parseInt(sketch.mouseY / TILEDATAHEIGHT);
        if (SELECTEDMAPTILE) {
            tilemapArray[SELECTEDMAPTILE.x][SELECTEDMAPTILE.y] = xTilePos + (yTilePos * HORIZONTALDATATILES);
            SELECTEDMAPTILE = undefined;
        } else {
            SELECTEDDATATILE = { x: xTilePos, y: yTilePos };
            SELECTEDDATATILEDATA = [...tiledataArray[xTilePos][yTilePos]];
            document.getElementById("tileeditor").style.visibility = "visible";
        }
    }
}

let tilemapArray = [];
for (var i = 0; i < 20; i++) {
    tilemapArray.push([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
}

var tilemap = function(sketch) {
    let TILEWIDTH;
    let TILEHEIGHT;
    let PIXELWIDTH;
    let PIXELHEIGHT;

    sketch.setup = function() {
        let parent = document.getElementById("tilemap");
        let WIDTH = parent.offsetWidth;
        let HEIGHT = parent.offsetHeight;
        TILEWIDTH = WIDTH / 20;
        TILEHEIGHT = HEIGHT / 18;
        PIXELWIDTH = TILEWIDTH / 8;
        PIXELHEIGHT = TILEHEIGHT / 8;
        let tilemapCanvas = sketch.createCanvas(WIDTH, HEIGHT);
        tilemapCanvas.parent("tilemap");
        tilemapCanvas.mousePressed(mouseClick);
    }

    sketch.draw = function() {
        for (var y = 0; y < tilemapArray.length; y++) {
            for (var x = 0; x < tilemapArray[y].length; x++) {
                let selectedTilePosition = tilemapArray[y][x];
                let selectedTileX = parseInt(selectedTilePosition % HORIZONTALDATATILES);
                let selectedTileY = parseInt(selectedTilePosition / HORIZONTALDATATILES);
                let selectedTile = tiledataArray[selectedTileX][selectedTileY];
                let TILEX = x * TILEWIDTH;
                let TILEY = y * TILEHEIGHT;
                if (SELECTEDMAPTILE && x == SELECTEDMAPTILE.y && y == SELECTEDMAPTILE.x) {
                    sketch.fill("purple");
                    sketch.rect(TILEX - 1, TILEY - 1, TILEWIDTH, TILEHEIGHT);
                    continue;
                }
                sketch.strokeWeight(2);
                sketch.rect(TILEX - 1, TILEY - 1, TILEWIDTH, TILEHEIGHT);
                for (var pixelY = 0; pixelY < selectedTile.length; pixelY++) {
                    for (var pixelX = 0; pixelX < selectedTile[pixelY].length; pixelX++) {
                        sketch.fill(colours[selectedTile[pixelY][pixelX]]);
                        sketch.strokeWeight(1);
                        sketch.rect(TILEX + (pixelX * PIXELWIDTH), TILEY + (pixelY * PIXELHEIGHT), PIXELWIDTH, PIXELHEIGHT);
                    }
                }
            }
        }
    }

    function mouseClick() {
        let xTilePos = parseInt(sketch.mouseY / TILEHEIGHT);
        let yTilePos = parseInt(sketch.mouseX / TILEWIDTH);
        SELECTEDMAPTILE = { x: xTilePos, y: yTilePos };
    }
}

var tileeditor = function(sketch) {
    let PIXELWIDTH;
    let PIXELHEIGHT;

    sketch.setup = function() {
        let parent = document.getElementById("editorcanvas");
        let WIDTH = parent.offsetWidth;
        let HEIGHT = parent.offsetHeight;
        PIXELWIDTH = WIDTH / 8;
        PIXELHEIGHT = HEIGHT / 8;
        let tilemapCanvas = sketch.createCanvas(WIDTH, HEIGHT);
        tilemapCanvas.parent("editorcanvas");
        tilemapCanvas.mousePressed(mouseClick);
    }

    sketch.draw = function() {
        if (!SELECTEDDATATILEDATA) return;
        for (var y = 0; y < SELECTEDDATATILEDATA.length; y++) {
            for (var x = 0; x < SELECTEDDATATILEDATA[y].length; x++) {
                sketch.fill(colours[SELECTEDDATATILEDATA[y][x]]);
                sketch.rect(x * PIXELWIDTH, y * PIXELHEIGHT, PIXELWIDTH, PIXELHEIGHT);
            }
        }
    }

    function mouseClick() {
        let xPixelPos = parseInt(sketch.mouseX / PIXELWIDTH);
        let yPixelPos = parseInt(sketch.mouseY / PIXELHEIGHT);
        SELECTEDDATATILEDATA[yPixelPos][xPixelPos] = (SELECTEDDATATILEDATA[yPixelPos][xPixelPos] + 1) % 4;
    }
}

new p5(tiledata);
new p5(tilemap);
new p5(tileeditor);

function closeClick() {
    document.getElementById("tileeditor").style.visibility = "hidden";
    SELECTEDDATATILE = undefined;
}