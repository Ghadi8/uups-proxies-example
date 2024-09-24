// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/Boxv1.sol";
import {BoxV2} from "../src/Boxv2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox deployer;
    UpgradeBox upgrader;

    address public proxy;

    function setUp() external {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();

        proxy = deployer.run(); // points to boxv1 now
    }

    function testProxyStartsAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(3);
    }

    function testUpgrades() public {
        BoxV2 newBox = new BoxV2();

        upgrader.upgradeBox(proxy, address(newBox));

        uint256 expectedVersionValue = 2;

        BoxV2(proxy).setNumber(7);

        assertEq(BoxV2(proxy).version(), expectedVersionValue, "Version value should be 2 after upgrade");

        assertEq(BoxV2(proxy).getNumber(), 7, "Number should be 7 after upgrade");
    }
}
