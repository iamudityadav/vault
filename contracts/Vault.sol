// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./interfaces/IERC20.sol";

contract Vault {
    IERC20 public immutable token;

    uint256 public totalSupply;
    mapping(address => uint256) public balance;
    
    constructor(address _token) {
        token = IERC20(_token);
    }

    function _mint(address _to, uint256 _amount) private {
        totalSupply += _amount;
        balance[_to] += _amount;
    }

    function _burn(address _from, uint256 _amount) private {
        totalSupply -= _amount;
        balance[_from] -= _amount;
    }

    function deposit(uint256 _amount) external {
        require(_amount > 0, "Invalid input.");
        uint256 shares;
        if(totalSupply == 0){
            shares = _amount;
        } else {
            shares = (_amount * totalSupply) / token.balanceOf(address(this)); 
        }

        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint256 _shares) external {
        require(_shares > 0 && balance[msg.sender] >= _shares, "Invalid input.");
        uint256 amount = (_shares * token.balanceOf(address(this))) / totalSupply;

        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);
    }
}
