// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IERC20
interface IERC20 {
    /// @notice Returns the amount of tokens in existence.
    function totalSupply() external view returns (uint256);

    /// @notice Returns the amount of tokens owned by `account`.
    function balanceOf(address account) external view returns (uint256);

    /// @notice Returns the remaining number of tokens that `spender` will be allowed to spend on
    /// behalf of `owner` through {transferFrom}. This is zero by default.
    /// @dev This value changes when {approve} or {transferFrom} are called.
    function allowance(address owner, address spender) external view returns (uint256);

    /// @notice Moves `amount` tokens from the caller's account to `recipient`.
    /// @dev Emits a {Transfer} event.
    /// @return A boolean value indicating whether the operation succeeded.
    function transfer(address to, uint256 amount) external returns (bool);

    /// @notice Moves `amount` tokens from `sender` to `recipient` using the allowance mechanism.
    /// `amount` is then deducted from the caller's allowance.
    /// @dev Emits a {Transfer} event.
    /// @return A boolean value indicating whether the operation succeeded.
    function transferFrom(address from, address to, uint256 amount) external returns (bool);

    /// @notice Sets `amount` as the allowance of `spender` over the caller's tokens.
    /// @dev IMPORTANT: Beware that changing an allowance with this method brings the risk that
    /// someone may use both the old and the new allowance by unfortunate transaction ordering. One
    /// possible solution to mitigate this race condition is to first reduce the spender's allowance
    /// to 0 and set the desired value afterwards:
    /// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    ///
    /// Emits an {Approval} event.
    /// @return A boolean value indicating whether the operation succeeded.
    function approve(address spender, uint256 amount) external returns (bool);
}
