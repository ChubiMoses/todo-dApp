const TodoList = artifacts.require("Migrations");

module.exports = function(deployer){
    deployer.deploy(Migrations);
}