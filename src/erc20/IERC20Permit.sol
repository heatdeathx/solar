// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20Metadata.sol";

/// @title IERC20Permit
interface IERC20Permit is IERC20Metadata {
    /// @notice Returns the current ERC2612 nonce for `owner`. This value must be included whenever
    /// a signature is generated for {permit}.
    /// @dev Every successful call to {permit} increases ``owner``'s nonce by one. This prevents a
    /// signature from being used multiple times.
    function nonces(address owner) external view returns (uint256);

    /// @notice Sets `amount` as the allowance of `spender` over `owner`'s tokens,
    /// given `owner`'s signed approval.
    /// @dev Emits an {Approval} event.
    /// @dev IMPORTANT: The same issues {IERC20-approve} has related to transaction ordering also
    /// apply here.
    /// @dev Requirements:
    ///
    /// - `owner` cannot be the zero address.
    /// - `spender` cannot be the zero address.
    /// - `deadline` must be a timestamp in the future.
    /// - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner` over the
    ///   EIP712-formatted function arguments.
    /// - the signature must use ``owner``'s current nonce (see {nonces}).
    ///
    /// For more information on the signature format, see the
    /// https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP section].
    function permit(
        address owner,
        address spender,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}
