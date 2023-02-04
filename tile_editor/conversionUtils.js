var binToD = {"0000":"0", "0001":"1", "0010":"2", "0011":"3", "0100":"4", "0101":"5", "0110":"6", "0111":"7", "1000":"8", "1001":"9", "1010":"A", "1011":"B", "1100":"C", "1101":"D", "1110":"E", "1111":"F"}

function convertTileToHex(tile) {
    let binaryConversion = convertTileToBinary(tile);
    let tileHex = "DB";
    for (var i = 0; i < binaryConversion.length; i++) {
        let leftNibble = binaryConversion[i].slice(0,4);
        let rightNibble = binaryConversion[i].slice(4,8);
        tileHex += ` $${binToD[leftNibble]}${binToD[rightNibble]}${(i != binaryConversion.length - 1) ? ',' : ';'}`;
    }
    return tileHex;
}

function convertTileToBinary(tile) {
    let tileBytes = [];
    for (var i = 0; i < tile.length; i++) {
        var topByte = "";
        var bottomByte = "";
        for (var j = 0; j < tile[i].length; j++) {
            if (tile[i][j] < 2) {
                topByte += "0";
            } else {
                topByte += "1";
            }
            if (tile[i][j] % 2 == 0) {
                bottomByte += "0";
            } else {
                bottomByte += "1";
            }
        }
        tileBytes.push(topByte);
        tileBytes.push(bottomByte);
    }
    return tileBytes;
}