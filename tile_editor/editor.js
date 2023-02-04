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

let colours = ["#0f380f", "#306230", "#8bac0f", "#9bbc0f"];

let selectedDrawColour = 3;
function selectColour(c) { selectedDrawColour = c; }

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
        if (SELECTEDMAPTILES.length > 0) {
            for (var i = 0; i < SELECTEDMAPTILES.length; i++) {
                tilemapArray[SELECTEDMAPTILES[i].x][SELECTEDMAPTILES[i].y] = xTilePos + (yTilePos * HORIZONTALDATATILES);
            }
            SELECTEDMAPTILES = [];
        } else {
            SELECTEDDATATILE = { x: xTilePos, y: yTilePos };
            SELECTEDDATATILEDATA = [...tiledataArray[xTilePos][yTilePos]];
            document.getElementById("tileeditor").style.visibility = "visible";
            document.getElementById("tilehex").value = convertTileToHex(SELECTEDDATATILEDATA);
        }
    }
}

let tilemapArray = [];
for (var i = 0; i < 32; i++) {
    tilemapArray.push([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
}

let SELECTEDMAPTILES = [];

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
        for (var y = 0; y < 20; y++) {
            for (var x = 0; x < 18; x++) {
                let selectedTilePosition = tilemapArray[y][x];
                let selectedTileX = parseInt(selectedTilePosition % HORIZONTALDATATILES);
                let selectedTileY = parseInt(selectedTilePosition / HORIZONTALDATATILES);
                let selectedTile = tiledataArray[selectedTileX][selectedTileY];
                let TILEX = x * TILEWIDTH;
                let TILEY = y * TILEHEIGHT;
                if (SELECTEDMAPTILES.some(tile => tile.x == y && tile.y == x)) {
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
        if (SELECTEDMAPTILES.some(tile => tile.x == xTilePos && tile.y == yTilePos)) {
            let index = -1;
            for (var i = 0; i < SELECTEDMAPTILES.length; i++) {
                if (SELECTEDMAPTILES[i].x == xTilePos && SELECTEDMAPTILES[i].y == yTilePos) {
                    index = i;
                    break;
                }
            }
            SELECTEDMAPTILES.splice(index, 1);
        } else {
            SELECTEDMAPTILES.push({ x: xTilePos, y: yTilePos });
        }
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
        SELECTEDDATATILEDATA[yPixelPos][xPixelPos] = selectedDrawColour;
        document.getElementById("tilehex").value = convertTileToHex(SELECTEDDATATILEDATA);
    }
}

new p5(tiledata);
new p5(tilemap);
new p5(tileeditor);

function closeClick() {
    document.getElementById("tileeditor").style.visibility = "hidden";
    SELECTEDDATATILE = undefined;
}

function toggleColours() {
    if (colours.includes("black")) {
        colours = ["#0f380f", "#306230", "#8bac0f", "#9bbc0f"];
        document.getElementById("body").style.backgroundColor = "#9bbc0f";
    } else {
        colours = ["black", "darkgrey", "lightgrey", "white"];
        document.getElementById("body").style.backgroundColor = "lightgrey";
    }
    let colourPicker = document.getElementsByClassName("colourSelect");
    for (var i = 0; i < 4; i++) {
        colourPicker[i].style.backgroundColor = colours[3-i];
    }
}

function exportTileData() {
    let tileDataString = "";
    for (var i = 0; i < VERTICALDATATILES; i++) {
        for (var j = 0; j < HORIZONTALDATATILES; j++) {
            tileDataString += `${i == 0 && j == 0 ? "" : "\n"}${convertTileToHex(tiledataArray[j][i])}`;
        }
    }
    download(document.getElementById("tiledata_filename").value, tileDataString);
}

function importTileData() {
    selectFile(e => { 
        let file = e.target.files[0];
        document.getElementById("tiledata_filename").value = file.name;
        readFile(file, e => {
                let hexData = e.target.result.replaceAll("DB", "").replaceAll("$", "").replaceAll(" ", "").replace(/\n\s*$/, "").split("\n");
                for (var i = hexData.length; i < 360; i++) {
                    hexData.push("00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00");
                }
                let newTiledataArray = [];
                for (var i = 0; i < HORIZONTALDATATILES; i++) {
                    let verticalDataTile = [];
                    for (var j = 0; j < VERTICALDATATILES; j++) {
                        verticalDataTile.push(convertHexToTile(hexData[i+j*HORIZONTALDATATILES].split(",")));
                    }
                    newTiledataArray.push(verticalDataTile);
                }
                tiledataArray = newTiledataArray;
            }
        );
    });
}

function exportTileMap() {
    let tileMapString = "";
    for (var i = 0; i < 32; i++) {
        tileMapString += `${i == 0 ? "" : "\n"}${convertRowToHex(tilemapArray[i].slice(0,16))}`;
        tileMapString += `\n${convertRowToHex(tilemapArray[i].slice(16,32))}`;
    }
    download(document.getElementById("tilemap_filename").value, tileMapString);
}

function importTileMap() {
    selectFile(e => { 
        let file = e.target.files[0];
        document.getElementById("tilemap_filename").value = file.name;
        readFile(file, e => {
                let hexData = e.target.result.replaceAll("DB", "").replaceAll("$", "").replaceAll(" ", "").replaceAll("\n", ",").split(",");
                for (var i = hexData.length; i < 32*32; i++) {
                    hexData.push("00");
                }
                let newTilemapArray = [];
                for (var i = 0; i < parseInt(hexData.length/32); i++) {
                    let pixelData =[];
                    for (var j = 0; j < 32; j++) {
                        pixelData.push(convertHexToDenary(hexData[i*32+j]));
                    }
                    newTilemapArray.push(pixelData);
                }
                tilemapArray = newTilemapArray;
            }
        );
    });
}

function download(filename, text) {
    var element = document.createElement('a');
    element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
    element.setAttribute('download', filename);
  
    element.style.display = 'none';
    document.body.appendChild(element);
  
    element.click();
  
    document.body.removeChild(element);
}

function selectFile(callback) {
    var input = document.createElement('input');
    input.type = 'file';
    input.onchange = callback;
    input.click();
}

function readFile(file, callback) {
    if (!file) return;
    var reader = new FileReader();
    reader.onload = callback;
    reader.readAsText(file);
}