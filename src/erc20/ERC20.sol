// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./IERC20Metadata.sol";
import "./IERC20Permit.sol";

/// @title ERC20
contract ERC20 is IERC20, IERC20Metadata, IERC20Permit {
    /// @notice Thrown when a `permit` with expired deadline is called.
    error DeadlineExpired();
    /// @notice Thrown when a call with insufficient allowance is executed.
    error InsufficientAllowance();
    /// @notice Thrown when a call with insufficient balance is executed.
    error InsufficientBalance();
    /// @notice Thrown when a `permit` with invalid signature is called.
    error InvalidSignature();

    /// @dev Emitted when tokens are moved from one address to another.
    event Transfer(address indexed from, address indexed to, uint256 value);
    /// @dev Emitted when `approval` or `permit` sets the allowance.
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /// @notice Returns the permit typehash.
    bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    /// @dev The internal `name`.
    string internal _name;
    /// @dev The internal `symbol`.
    string internal _symbol;
    /// @dev The internal `decimals`.
    uint8 internal immutable _decimals;
    /// @dev The internal `totalSupply`.
    uint256 internal _totalSupply;
    /// @dev The internal `balanceOf`.
    mapping(address => uint256) internal _balanceOf;
    /// @dev The internal `allowance`.
    mapping(address => mapping(address => uint256)) internal _allowance;

    /// @dev The internal chain id set at deployment.
    uint256 internal immutable _chainid;
    /// @dev The internal domain separator set at deployment.
    bytes32 internal immutable _domainseparator;
    /// @dev The internal nonces.
    mapping(address => uint256) internal _nonces;

    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;

        _chainid = block.chainid;
        _domainseparator = domainseparator_();
    }

    /// @inheritdoc IERC20Permit
    function DOMAIN_SEPARATOR() public virtual view returns (bytes32) {
        return block.chainid == _chainid ? _domainseparator : domainseparator_();
    }

    /// @inheritdoc IERC20Metadata
    function name() external view virtual returns (string memory) {
        return _name;
    }

    /// @inheritdoc IERC20Metadata
    function symbol() external view virtual returns (string memory) {
        return _symbol;
    }

    /// @inheritdoc IERC20Metadata
    function decimals() external view virtual returns (uint8) {
        return _decimals;
    }

    /// @dev Override to change version.
    function version() public pure virtual returns (string memory) {
        return "1";
    }

    /// @inheritdoc IERC20
    function totalSupply() external view virtual returns (uint256) {
        return _totalSupply;
    }

    /// @inheritdoc IERC20
    function balanceOf(address account) external view virtual returns (uint256) {
        return _balanceOf[account];
    }

    /// @inheritdoc IERC20
    function allowance(address owner, address spender) external view virtual returns (uint256) {
        return _allowance[owner][spender];
    }

    /// @inheritdoc IERC20Permit
    function nonces(address owner) external view virtual returns (uint256) {
        return _nonces[owner];
    }

    /// @inheritdoc IERC20
    function transfer(address to, uint256 amount) external virtual returns (bool) {
        _transfer(msg.sender, to, amount);

        return true;
    }

    /// @inheritdoc IERC20
    function transferFrom(address from, address to, uint256 amount) external virtual returns (bool) {
        if (from != msg.sender) {
            uint256 allowed = _allowance[from][msg.sender];

            if (allowed != type(uint256).max) {
                if (allowed < amount) {
                    revert InsufficientAllowance();
                }

                unchecked { _approve(from, msg.sender, allowed - amount); }
            }
        }

        _transfer(from, to, amount);

        return true;
    }

    /// @inheritdoc IERC20
    function approve(address spender, uint256 amount) external virtual returns (bool) {
        _approve(msg.sender, spender, amount);

        return true;
    }

    /// @inheritdoc IERC20Permit
    function permit(
        address owner,
        address spender,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual {
        if (deadline < block.timestamp)
            revert DeadlineExpired();

        bytes32 hash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR(),
                keccak256(
                    abi.encode(
                        PERMIT_TYPEHASH,
                        owner,
                        spender,
                        amount,
                        _nonces[owner]++,
                        deadline
                    )
                )
            )
        );
        address signer = ecrecover(hash, v, r, s);

        if (signer == address(0) || signer != owner)
            revert InvalidSignature();

        _approve(owner, spender, amount);
    }

    /// @dev Returns the domain separator.
    function domainseparator_() internal virtual view returns (bytes32) {
        return keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainid,address verifyingContract)"),
                keccak256(bytes(_name)),
                keccak256(bytes(version())),
                block.chainid,
                address(this)
            )
        );
    }

    /// @dev Move `amount` tokens from `from` to `to`.
    function _transfer(address from, address to, uint256 amount) internal virtual {
        if (_balanceOf[from] < amount)
            revert InsufficientBalance();

        _before(from, to, amount);

        unchecked {
            _balanceOf[from] -= amount;
            _balanceOf[to] += amount;
        }
        emit Transfer(from, to, amount);

        _after(from, to, amount);
    }

    /// @dev Creates `amount` tokens and assign them to `to`, increasing the total supply.
    function _mint(address to, uint amount) internal virtual returns (bool) {
        _before(address(0), to, amount);

        _totalSupply += amount;
        unchecked { _balanceOf[to] += amount; }
        emit Transfer(address(0), to, amount);

        _after(address(0), to, amount);

        return true;
    }

    /// @dev Destroys `amount` tokens from `from`, decreasing the total supply.
    function _burn(address from, uint256 amount) internal virtual returns (bool) {
        _before(from, address(0), amount);

        _balanceOf[from] -= amount;
        unchecked { _totalSupply -= amount; }
        emit Transfer(from, address(0), amount);

        _after(from, address(0), amount);

        return true;
    }

    /// @dev Approve `amount` tokens to the `spender` by the `owner`.
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        _allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /// @notice Hook that is called before any transfer of tokens (includes minting and burning).
    /// @dev Calling conditions:
    ///
    /// - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens will be transferred
    ///   to `to`.
    /// - when `from` is zero, `amount` tokens will be minted for `to`.
    /// - when `to` is zero, `amount` of ``from``'s tokens will be burned.
    /// - `from` and `to` are never both zero.
    function _before(address from, address to, uint256 amount) internal virtual {}

    /// @dev Hook that is called after any transfer of tokens (includes minting and burning).
    /// @dev Calling conditions:
    ///
    /// - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens has been transferred
    ///   to `to`.
    /// - when `from` is zero, `amount` tokens have been minted for `to`.
    /// - when `to` is zero, `amount` of ``from``'s tokens have been burned.
    /// - `from` and `to` are never both zero.
    function _after(address from, address to, uint256 amount) internal virtual {}
}
