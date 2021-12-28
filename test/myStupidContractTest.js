const { eqauls, assert } = require('chai')
const { ethers } = require('hardhat')

const accounts = []

describe('MyStupidContract Test', async () => {
  before(async () => {
    const MyStupidContract = await ethers.getContractFactory('MyStupidContract')
    myStupidContract = await MyStupidContract.deploy()
    await myStupidContract.deployed();

    const signers = await ethers.getSigners()
    signers.forEach(signer => accounts.push(signer))
  })
  it('does nothing', () => {

  })
})