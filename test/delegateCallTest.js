const { expect } = require("chai");
const { ethers } = require("hardhat");

let owner, tx
let contract1, contract2, delegateCall
const accounts = []

describe('Delegate Call', async () => {
  before(async () => {
    const signers = await ethers.getSigners()
    signers.forEach(signer => { accounts.push(signer) })

    const Contract1 = await ethers.getContractFactory('Satellite1')
    contract1 = await Contract1.deploy()
    await contract1.deployed()

    const DelegateCall = await ethers.getContractFactory('DelegateCall')
    delegateCall = await DelegateCall.deploy()
    await delegateCall.deployed()

    const Contract2 = await ethers.getContractFactory('Satellite2')
    contract2 = await Contract2.deploy()
    await contract2.deployed()
  })

  it('should call the first contract', async () => {
    tx = await delegateCall.setVars(contract1.address, '5');
    await tx.wait()
    
    tx = await delegateCall.getVars(contract1.address)
    // console.log(tx)
    tx = await tx.wait()
    // console.log(tx)
  })
})