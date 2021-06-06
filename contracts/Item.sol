pragma solidity ^0.7.0;

import "./ItemManager.sol"; 

contract Item {
    uint  public price;
    uint  public pricePaid;
    uint  public index;
    ItemManager parentContract;
    
    constructor(uint _price , uint _index , ItemManager _itemManger){
        price = _price ;
        index = _index;
        parentContract = _itemManger;
    }
    
    receive () external payable {
        require(price == msg.value ,"only full amount accpeted");
        require(pricePaid == 0 ,"already paid");
        pricePaid += msg.value;
       
        (bool success,) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("trigerPayment(uint256)" , index));
        require(success , "Delivery did not work , canacelling ");
    
    }
    
    fallback ()  external  {

    }
}
