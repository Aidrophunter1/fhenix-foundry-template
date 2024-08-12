// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";

import { Permission, Permissioned} from "@fhenixprotocol/contracts/access/Permissioned.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

import {PermissionHelper} from "../util/PermissionHelper.sol"; 

contract PermissionedTest is Test {
    PermissionedTestContract permissions;
    PermissionHelper permit_helper;

    address owner;
    uint256 ownerPrivateKey;

    function setUp() public {
        permissions = new PermissionedTestContract();
        permit_helper = new PermissionHelper(address(permissions));
    }

    function test_OnlySender() external {
        // Generate permission
        ownerPrivateKey = 0xA11CE;
        owner = vm.addr(ownerPrivateKey);
        
        Permission memory permission = permit_helper.generatePermission(ownerPrivateKey, bytes32(0));

        console2.log(owner);

        // Call function with permission
        uint256 result = permissions.someFunctionWithOnlySender(owner, permission);
        assertEq(result, 42);
    }
}

contract PermissionedTestContract is Permissioned {
    function someFunctionWithOnlySender(address owner, Permission memory permission) public onlyPermitted(permission, owner) returns (uint256) {
        return 42;
    }
}