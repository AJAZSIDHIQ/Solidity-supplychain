const ItemManager = artifacts.require("./ItemManager.sol");


contract("itemManager" , accounts => {

    it( "... should let you create new Items " , async () => {
        const itemManagerinst = await ItemManager.deployed();
        const itemName = "test1" ;
        const cost = 500

        const result = await itemManagerinst.createItem(itemName , cost ,{ from : accounts[0]});
        assert.equal(result.logs[0].args._itemInde , 0 ,  "There should be one item index in there")

        const item =await itemManagerinst.items(0);
        assert.equal(item._identifier, itemName, "The item has a different identifier");

    })

})