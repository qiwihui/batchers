// SPDX-License-Identifier: GPL-3.0
import "forge-std/Test.sol";
import "../src/Batcher.sol";
pragma solidity >=0.7.0 <0.9.0;

contract Storage {
    uint256 number;

    function store(uint256 num) public {
        number += num;
    }

    function retrieve() public view returns (uint256) {
        return number;
    }
}

interface IERC20 {
    function balanceOf(address owner) external view returns (uint256);
}

interface IXen {
    function claimRank(uint256 term) external;

    function claimMintReward() external;

    function claimMintRewardAndShare(address other, uint256 pct) external;
}

contract BatcherTest is Test {
    Storage store;
    Batcher batcher;

    function setUp() public {
        store = new Storage();
        batcher = new Batcher(1);
    }

    function testCallExecute() public {
        assertEq(store.retrieve(), 0);
        batcher.increase(9);
        bytes memory call = abi.encodeWithSelector(Storage.store.selector, 1);
        batcher.execute(0, 10, address(store), call);
        assertEq(store.retrieve(), 10);
    }

    function testXen() public {
        vm.createSelectFork("mainnet", 15743623);
        vm.warp(1665721472);
        address xenAddress = 0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8;
        IXen(xenAddress).claimRank(1);

        vm.warp(1665721472 + 24 * 3600 + 1);
        uint256 balanceBefore = IERC20(xenAddress).balanceOf(address(this));
        console.log("Xen balance before: ", balanceBefore);
        IXen(xenAddress).claimMintRewardAndShare(address(this), 100);
        uint256 balanceAfter = IERC20(xenAddress).balanceOf(address(this));
        console.log("Xen balance after: ", balanceAfter);
        assertLt(balanceBefore, balanceAfter);
    }
}
