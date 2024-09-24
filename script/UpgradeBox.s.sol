// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "@foundry-devops/contracts/DevOpsTools.sol";
import {BoxV2} from "../src/Boxv2.sol";
import {BoxV1} from "../src/Boxv1.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
        vm.startBroadcast();
        BoxV2 newBox = new BoxV2(); // Implementation
        vm.stopBroadcast();

        address proxy = upgradeBox(mostRecentlyDeployed, address(newBox));
        return proxy;
    }

    function upgradeBox(address proxy, address newImplementation) public returns (address) {
        vm.startBroadcast();
        BoxV1(proxy).upgradeToAndCall(newImplementation, "");
        vm.stopBroadcast();
        return proxy;
    }
}
