//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
}

// 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f

interface IUniswapV2Router01 {
    //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}
