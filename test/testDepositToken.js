const { ethers } = require("hardhat");

describe("DepositSingle", function () {
  it("Should return the new greeting once it's changed", async function () {
    [owner, add1, add2] = await ethers.getSigners();
    const DepositSingle = await ethers.getContractFactory("DepositSingle");
    const DS = await DepositSingle.deploy();
    const dai = "0x6b175474e89094c44da98b954eedeac495271d0f";
    const usdc = "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48";
    const usdt = "0xdac17f958d2ee523a2206206994597c13d831ec7";
    const account = "0xe78388b4ce79068e89bf8aa7f218ef6b9ab0e9d0";
    await DS.deployed();

    const tokenArtifact = await artifacts.readArtifact("IERC20");
    const token = new ethers.Contract(dai, tokenArtifact.abi, ethers.provider);

    await network.provider.send("hardhat_setBalance", [
      account,
      ethers.utils.parseEther('10.0').toHexString(),
    ]);

    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [account],
    });
    const signer = await ethers.getSigner(account);
    await token.connect(signer).approve(DS.address, ethers.utils.parseUnits("100", 18))
    await DS.connect(signer).deposit(dai,[usdc, usdt], ethers.utils.parseUnits("100", 18));

    await hre.network.provider.request({
      method: "hardhat_stopImpersonatingAccount",
      params: [account],
    });
  });
});
