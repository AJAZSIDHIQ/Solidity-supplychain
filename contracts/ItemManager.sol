pragma solidity ^0.7.0;

import "./Item.sol"; 
import "./Ownable.sol";

contract ItemManager is Ownable {
    
    enum SupplyChainState{Created,Paid , Delivered}
    
    struct S_item {
        Item item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }
    mapping(uint => S_item) public items;
    uint itemIndex;
    
    event SupplyChainStep(uint _itemInde, uint _step , address _address);
    
    function createItem(string memory _identifier , uint _itemPrice ) public onlyOwner{
        Item _item = new Item(_itemPrice , itemIndex , this);
        items[itemIndex].item = _item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex , uint(items[itemIndex]._state), address(_item));
        itemIndex++;
    }
    
    function trigerPayment(uint _itemIndex) public  payable {
        Item item = items[_itemIndex].item;
        require(address(item) == msg.sender, "Only items are allowed to update themselves");
        require(item.price() == msg.value, "Not fully paid yet");
        require(items[_itemIndex]._state == SupplyChainState.Created , "item is further in the chain");
        items[_itemIndex]._state = SupplyChainState.Paid;
        emit SupplyChainStep(_itemIndex , uint(items[_itemIndex]._state) , address(items[_itemIndex].item));
        
    }
    
    function triggerDelivery(uint _itemIndex)  public onlyOwner {
        require(items[_itemIndex]._state == SupplyChainState.Paid , "item is further in the chain");
        items[_itemIndex]._state = SupplyChainState.Delivered;
         emit SupplyChainStep(_itemIndex , uint(items[_itemIndex]._state) , address(items[_itemIndex].item));
    }
}
