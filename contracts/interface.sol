//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.6;

interface IUniswapV2Factory {
    // 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
}

interface IUniswapV2Router01 {
    //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );
}
