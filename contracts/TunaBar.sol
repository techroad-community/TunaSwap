pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract TunaBar is ERC20("TunaBar", "xTUNA"){
    using SafeMath for uint256;
    IERC20 public tuna;

    constructor(IERC20 _tuna) public {
        tuna = _tuna;
    }

    // Enter the bar. Pay some TUNAs. Earn some shares.
    function enter(uint256 _amount) public {
        uint256 totalTuna = tuna.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        if (totalShares == 0 || totalTuna == 0) {
            _mint(msg.sender, _amount);
        } else {
            uint256 what = _amount.mul(totalShares).div(totalTuna);
            _mint(msg.sender, what);
        }
        tuna.transferFrom(msg.sender, address(this), _amount);
    }

    // Leave the bar. Claim back your TUNAs.
    function leave(uint256 _share) public {
        uint256 totalShares = totalSupply();
        uint256 what = _share.mul(tuna.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        tuna.transfer(msg.sender, what);
    }
}
