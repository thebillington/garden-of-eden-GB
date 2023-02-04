let binToHex = {"0000":"0", "0001":"1", "0010":"2", "0011":"3", "0100":"4", "0101":"5", "0110":"6", "0111":"7", "1000":"8", "1001":"9", "1010":"A", "1011":"B", "1100":"C", "1101":"D", "1110":"E", "1111":"F"};
let hexToBin = {"0":"0000", "1":"0001", "2":"0010", "3":"0011", "4":"0100", "5":"0101", "6":"0110", "7":"0111", "8":"1000", "9":"1001", "A":"1010", "B":"1011", "C":"1100", "D":"1101", "E":"1110", "F":"1111"};
let binToDen = {"00":3, "01": 2, "10": 1, "11": 0}

function convertTileToHex(tile) {
    let binaryConversion = convertTileToBinary(tile);
    let tileHex = "DB";
    for (var i = 0; i < binaryConversion.length; i++) {
        let leftNibble = binaryConversion[i].slice(0,4);
        let rightNibble = binaryConversion[i].slice(4,8);
        tileHex += ` $${binToHex[leftNibble]}${binToHex[rightNibble]}${(i != binaryConversion.length - 1) ? ',' : ';'}`;
    }
    return tileHex;
}

function convertHexToTile(hexTile) {
    let tileData = [];
    for (var i = 0; i < hexTile.length; i+=2) {
        let topByte = "";
        let bottomByte = "";
        topByte += hexToBin[hexTile[i].slice(0,1)];
        topByte += hexToBin[hexTile[i].slice(1,2)];
        bottomByte += hexToBin[hexTile[i+1].slice(0,1)];
        bottomByte += hexToBin[hexTile[i+1].slice(1,2)];
        let pixelData = [];
        for (var j = 0; j < topByte.length; j++) {
            pixelData.push(binToDen[topByte[j]+bottomByte[j]]);
        }
        tileData.push(pixelData);
    }
    return tileData;
}

function convertTileToBinary(tile) {
    let tileBytes = [];
    for (var i = 0; i < tile.length; i++) {
        var topByte = "";
        var bottomByte = "";
        for (var j = 0; j < tile[i].length; j++) {
            if (tile[i][j] < 2) {
                topByte += "1";
            } else {
                topByte += "0";
            }
            if (tile[i][j] % 2 == 0) {
                bottomByte += "1";
            } else {
                bottomByte += "0";
            }
        }
        tileBytes.push(topByte);
        tileBytes.push(bottomByte);
    }
    return tileBytes;
}