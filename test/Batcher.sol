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
        bytes memory call= abi.encodeWithSelector(Storage.store.selector, 1);
        batcher.execute(0, 10, address(store), call);
        assertEq(store.retrieve(), 10);
    }
}
