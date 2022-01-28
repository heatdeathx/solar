// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Lock
/// @notice Prevents reentrancy.
abstract contract Lock {
    /// @notice Thrown when the contract is locked using the `lock` modifier.
    error Locked();

    /// @dev The variable is initialized non-zero as refunds are capped.
    /// Read more: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ae54e6de1d77c60881e4c85ffbdb7f9d76b71efe/contracts/security/ReentrancyGuard.sol
    uint256 private _locked = 1;

    modifier lock() {
        if (_locked != 2)
            revert Locked();

        _locked = 2;
        _;
        _locked = 1;
    }
}
