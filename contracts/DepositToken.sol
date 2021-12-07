//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./interface.sol";
import "@uniswap/v2-periphery\contracts\libraries\UniswapV2Library.sol";   //npm i @uniswap/v2-periphery
import "@openzeppelin/contracts\token\ERC20\IERC20.sol";      

contract DepositSingle {


    function deposit(address inputToken, address[] memory tokenPair, uint256 amt) public {

        address tokenA = tokenPair[0];     //To Swap Tokens
        address tokenB = tokenPair[1];

        (uint256 reserve0A, uint256 reserve0B) = getReserves(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f,inputToken,tokenA);  //Got Reserve Values Of Tokens

        uint256 amountOutMin01 = getAmountOut(amt / 2, reserve0A, reserve0B);  //min output of tokens to receive after swap.

        IUniswapV2Router01 router01 = IUniswapV2Router01(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);  

        IUniswapV2Factory Factory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);

        address memory path01 = new address[](2);          //Path To Swap
        path01[0] = inputToken;
        path01[1] = tokenA;

        uint256[] memory amountLP01 = router01.swapExactTokensForTokens(amt / 2,amountOutMin01, path01,address(this),block.timestamp + 360);
        //Swaped Tokens

        //----------------For Token B-------------------------

        (uint256 reserve1A, uint256 reserve1B) = getReserves(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f,inputToken,tokenB);

        uint256 amountOutMin02 = getAmountOut(amt / 2, reserve1A, reserve1B);

    

        address memory path02 = new address[](2);
        path02[0] = inputToken;
        path02[1] = tokenB;

        uint256[] memory amountLP02 = router01.swapExactTokensForTokens(
            amt / 2,
            amountOutMin02,
            path02,
            address(this),
            block.timestamp + 360
        );

        IERC20 tokenALP = IERC20(tokenA);
        IERC20 tokenBLP = IERC20(tokenB);
    }
}
