//SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;

import "./interface.sol"; //npm i @uniswap/v2-periphery
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./helper.sol";
import "hardhat/console.sol";

contract DepositSingle is UniswapV2Library {
    using SafeERC20 for IERC20;

    function deposit(
        address inputToken,
        address[] memory tokenPair,
        uint256 amt
    ) public {
        IERC20 InputToken = IERC20(inputToken);

        InputToken.transferFrom(msg.sender, address(this), amt);
        (uint256 reserve0A, uint256 reserve0B) = getReserves(
            0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f,
            inputToken,
            tokenPair[0]
        ); //Got Reserve Values Of Tokens

        uint256 amountOutMin01 = getAmountOut(amt / 2, reserve0A, reserve0B); //min output of tokens to receive after swap.

        IUniswapV2Router01 router01 = IUniswapV2Router01(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );

        IUniswapV2Factory Factory = IUniswapV2Factory(
            0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
        );

        address[] memory path01 = new address[](2); //Path To Swap
        path01[0] = inputToken;
        path01[1] = tokenPair[0];

        InputToken.approve(address(router01), amt / 2);

        uint256[] memory amountLP01 = router01.swapExactTokensForTokens(
            amt / 2,
            amountOutMin01,
            path01,
            address(this),
            block.timestamp + 360
        );
        //Swaped Tokens

        //----------------For Token B-------------------------

        (uint256 reserve1A, uint256 reserve1B) = getReserves(
            0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f,
            inputToken,
            tokenPair[1]
        );

        uint256 amountOutMin02 = getAmountOut(amt / 2, reserve1A, reserve1B);

        address[] memory path02 = new address[](2);
        path02[0] = inputToken;
        path02[1] = tokenPair[1];
        uint256 amount = amt / 2;
        InputToken.approve(address(router01), amount);

        uint256[] memory amountLP02 = router01.swapExactTokensForTokens(
            amount,
            amountOutMin02,
            path02,
            address(this),
            block.timestamp + 360
        );

        IUniswapV2Router01 router10 = router01;

        IERC20(path01[1]).safeApprove(address(router10), amountLP01[1]);

        IERC20(path02[1]).safeApprove(address(router10), amountLP02[1]);

        uint256 amt0 = amountLP01[1];
        uint256 amt1 = amountLP02[1];
        (uint256 adepo, uint256 bdepo, uint256 lpt) = router10.addLiquidity(
            path01[1],
            path02[1],
            amt0,
            amt1,
            (amt0 * 99) / 100,
            (amt1 * 99) / 100,
            msg.sender,
            block.timestamp + 360
        );
    }
}
