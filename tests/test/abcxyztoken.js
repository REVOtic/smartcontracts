var Token = artifacts.require("ABCxyzToken");

contract('abcxyztoken', function(accounts) {
  it("should assert true", function() {
    var token;
    return Token.deployed().then(function(instance){
     token = instance;
     console.log(token.totalSupply.call());
     return token.totalSupply.call();
    }).then(function(result){
      assert.equal(result.toNumber(), 10000, 'total supply is wrong');
    })
  });

  it("should return the balance of token owner", function() {
    var token;
    return Token.deployed().then(function(instance){
      token = instance;
      console.log(token.balanceOf.call(accounts[0]));
      return token.balanceOf.call(accounts[0]);
    }).then(function(result){
      assert.equal(result.toNumber(), 1000000, 'balance is wrong');
    })
  });

  it("should transfer right token", function() {
    var token;
    return Token.deployed().then(function(instance){
      token = instance;
      console.log(token.transfer(accounts[1], 500000));
      return token.transfer(accounts[1], 500000);
    }).then(function(){
      console.log(token.balanceOf.call(accounts[0]));
      return token.balanceOf.call(accounts[0]);
    }).then(function(result){
      assert.equal(result.toNumber(), 500000, 'accounts[0] balance is wrong');
      console.log(token.balanceOf.call(accounts[1]));
      return token.balanceOf.call(accounts[1]);
    }).then(function(result){
      assert.equal(result.toNumber(), 500000, 'accounts[1] balance is wrong');
    })
  });

  it("should give accounts[1] authority to spend account[0]'s token", function() {
    var token;
    return Token.deployed().then(function(instance){
     token = instance;
     console.log(token.approve(accounts[1], 200000));
     return token.approve(accounts[1], 200000);
    }).then(function(){
      console.log(token.allowance.call(accounts[0], accounts[1]))
     return token.allowance.call(accounts[0], accounts[1]);
    }).then(function(result){
     assert.equal(result.toNumber(), 200000, 'allowance is wrong');
     console.log(token.transferFrom(accounts[0], accounts[2], 200000, {from: accounts[1]}));
     return token.transferFrom(accounts[0], accounts[2], 200000, {from: accounts[1]});
    }).then(function(){
      console.log(token.balanceOf.call(accounts[0]));
     return token.balanceOf.call(accounts[0]);
    }).then(function(result){
      console.log(token.balanceOf.call(accounts[1]));
     assert.equal(result.toNumber(), 300000, 'accounts[0] balance is wrong');
     return token.balanceOf.call(accounts[1]);
    }).then(function(result){
      console.log(token.balanceOf.call(accounts[2]));
     assert.equal(result.toNumber(), 500000, 'accounts[1] balance is wrong');
     return token.balanceOf.call(accounts[2]);
    }).then(function(result){
     assert.equal(result.toNumber(), 200000, 'accounts[2] balance is wrong');
    })
  });

  it("mint coin into account[2]", function(){
    var token;
    return Token.deployed().then(function(instance){
      token = instance;
      return token.mintToken(accounts[2], 20000, {from:accounts[0]});
    }).then(function(){
      return token.balanceOf.call(accounts[2]);
    }).then(function(result){
      assert.equal(result.toNumber(), 200000, 'account[2] balance is wrong');
    })
  });

});