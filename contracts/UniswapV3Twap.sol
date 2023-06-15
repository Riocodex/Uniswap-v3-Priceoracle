//SPDX-License-Identifier:MIT
pragma solidity 0.7.6;

import "@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3Factory.sol";
import "@uniswap/lib/contracts/libraries/OracleLibrary.sol";

contract UniswapV3Twap {
    address public immutable token0;
    address public immutable token1;
    address public immutable pool;


    constructor(address _factory,address _token0, address _token1,uint24 fee) {
        token0 = _token0;
        token1 = _token1;

        address _pool = IUniswapV3Factory(_factory).getPool(
            _token0, _token1, _fee
        );
        require(_pool != address(0), "pool doesnt exist");
        pool = _pool;
    } 

    function estimateAmountOut(
        address tokenIn,
        uint128 amountIn,
        uint132 secondsAgo
    )external view returns (uint amountOut) {
        require(tokenIn == token0 || tokenIn == token1, "invalid token");
        address tokenOut = tokenIn == token0 ? token1 : token0;
        (int24 tick, ) = OracleLibrary.consult(pool, secondsAgo);
        amountOut = OracleLibrary.getQuoteAtTick(
            tick, amountIn, tokenIn, tokenOut
        );
    }
}