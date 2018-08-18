let Web3 = require("web3")
let fs = require("fs")
let path = require("path")

// "Web3.providers.givenProvider" will be set if in an Ethereum supported browser.
var web3 = new Web3(Web3.givenProvider || 'http://127.0.0.1:8545');

let contractPath = path.join(__dirname, "build", "MyToken.json")
let data = fs.readFileSync(contractPath, "utf8")
let jsonObject = JSON.parse(data)
//通过编译后的interface获取到合约实列。
var myContract = new web3.eth.Contract(JSON.parse(jsonObject.interface))
console.log(myContract)
//部署myContract
myContract.deploy({
    data: "0x" + jsonObject.bytecode,
    arguments: ["侯晓磊", "HXL", 0, 10000]
})
    .send({
        from: '0x024ad28375baf0556c906c20066536851a12b9e9',
        gas: 1500000,
        gasPrice: '30000000000'
    }, function (error, transactionHash) {
        console.log(transactionHash)
    })
    .on('error', function (error) {
        console.log(error)
    })
    .then(async function (newContractInstance) {
        console.log(newContractInstance.options.address) // instance with the new contract address
        newContractInstance.methods.name().call()
            .then(function (r) {
                console.log(r)
            })
        let name = await newContractInstance.methods.name().call()
        let symbol = await newContractInstance.methods.symbol().call()
        let decimals = await newContractInstance.methods.decimals().call()
        let totalSupply = await newContractInstance.methods.totalSupply().call()
        console.log(name)
        console.log(symbol)
        console.log(totalSupply)
        console.log(decimals)
    });