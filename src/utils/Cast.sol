// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Cast {
    /// @notice Thrown when a cast overflows.
    error CastOverflow();

    function u224(uint256 x) internal pure returns (uint224 y) {
        if (x > type(uint224).max)
            revert CastOverflow();

        y = uint224(x);
    }

    function u128(uint256 x) internal pure returns (uint128 y) {
        if (x > type(uint128).max)
            revert CastOverflow();

        y = uint128(x);
    }

    function u112(uint256 x) internal pure returns (uint112 y) {
        if (x > type(uint112).max)
            revert CastOverflow();

        y = uint112(x);
    }

    function u96(uint256 x) internal pure returns (uint96 y) {
        if (x > type(uint96).max)
            revert CastOverflow();

        y = uint96(x);
    }

    function u64(uint256 x) internal pure returns (uint64 y) {
        if (x > type(uint64).max)
            revert CastOverflow();

        y = uint64(x);
    }

    function u32(uint256 x) internal pure returns (uint32 y) {
        if (x > type(uint32).max)
            revert CastOverflow();

        y = uint32(x);
    }

    function u24(uint256 x) internal pure returns (uint24 y) {
        if (x > type(uint24).max)
            revert CastOverflow();

        y = uint24(x);
    }

    function u16(uint256 x) internal pure returns (uint16 y) {
        if (x > type(uint16).max)
            revert CastOverflow();

        y = uint16(x);
    }

    function u8(uint256 x) internal pure returns (uint8 y) {
        if (x > type(uint8).max)
            revert CastOverflow();

        y = uint8(x);
    }
}
