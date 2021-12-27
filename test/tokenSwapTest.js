const { expect } = require("chai");
const { ethers } = require("hardhat");

let owner, tx
const accounts = []

describe("TokenSwap", function () {
  before(async () => {
    const signers = await ethers.getSigners()
    for (let i = 0; i < 10; i++) {
      accounts.push(signers[i])
    }
    owner = accounts[0]
  })
  it("It should swap tokens", async function () {
    const BobToken = await ethers.getContractFactory("BobToken")
    const bobToken = await BobToken.connect(accounts[1]).deploy('BobToken', 'BTN')
    await bobToken.deployed()
    tx = await bobToken.balanceOf(accounts[1].address)
    console.log(ethers.utils.formatEther(tx))
    console.log(tx)

    const AliceToken = await ethers.getContractFactory("BobToken")
    const aliceToken = await AliceToken.connect(accounts[2]).deploy('AliceToken', 'ATN')
    await aliceToken.deployed()
    tx = await aliceToken.connect(accounts[2]).balanceOf(accounts[2].address)
    console.log(ethers.utils.formatEther(tx))

    const TokenSwap = await ethers.getContractFactory("TokenSwap")
    const tokenSwap = await TokenSwap.deploy(bobToken.address, accounts[1].address, aliceToken.address, accounts[2].address);
    await tokenSwap.deployed()

    tx = await bobToken.connect(accounts[1]).approve(tokenSwap.address, ethers.utils.parseUnits('5', 18))
    await tx.wait()
    console.log(ethers.utils.formatUnits(await bobToken.allowance(accounts[1].address, tokenSwap.address), 18))

    // await bobToken.connect(accounts[1]).transfer(tokenSwap.address, '10')

    tx = await aliceToken.connect(accounts[2]).approve(tokenSwap.address, ethers.utils.parseUnits('5', 18))
    await tx.wait()
    console.log(ethers.utils.formatUnits(await aliceToken.allowance(accounts[2].address, tokenSwap.address), 18))
    
    // await aliceToken.connect(accounts[2]).transfer(tokenSwap.address, '10')
    
    tx = await tokenSwap.connect(accounts[2]).swap(ethers.utils.parseUnits('1', 18), ethers.utils.parseUnits('5', 18))

    tx = await bobToken.balanceOf(accounts[2].address)
    console.log(ethers.utils.formatUnits(tx, 18))

    tx = await aliceToken.connect(accounts[2]).balanceOf(accounts[1].address)
    console.log(ethers.utils.formatUnits(tx, 18))
  });
});
