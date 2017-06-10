var regMod = artifacts.require("./other/managedreg.sol");


contract('regMod', function(accounts) {
  it("should have no owner", function() {
    return regMod.deployed().then(function(instance) {
      return instance.ownerCheck.call(accounts[0]);
    }).then(function(owner) {
      assert.equal(owner.valueOf(), 0, "the owner is empty");
    });
  });
});
