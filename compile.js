var solc = require('solc')
var fs = require("fs")
var path = require("path")

let filePath = path.join(__dirname, "contract/MyToken.sol")
let data = fs.readFileSync(filePath, 'utf8')
console.log(data)

// Setting 1 as second paramateractivates the optimiser
var output = solc.compile(data, 1)
for (var contractName in output.contracts) {
    // code and ABI that are needed by web3
    console.log(contractName + ': ' + output.contracts[contractName].bytecode)
    console.log(contractName + '; ' + JSON.parse(output.contracts[contractName].interface))

    let buildContractPath = path.join(__dirname, "build", contractName.replace(":", "") + '.json')
    console.log(buildContractPath)
    fs.writeFileSync(buildContractPath, JSON.stringify(output.contracts[contractName], null, 4))
}