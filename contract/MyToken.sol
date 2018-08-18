pragma solidity ^0.4.0;


contract EIP20Interface {
    uint256 public totalSupply;

    function balanceOf(address _owner) view returns (uint256 balance);

    // 转账：调用方向_to转_value个token
    function transfer(address _to, uint256 _value) returns (bool success);
    // 转账：从_from向_to转_value个token
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    // 允许_spender从自己（调用方）账户转走_value个token
    function approve(address _spender, uint256 _value) returns (bool success);
    // 自己（_owner）查询_spender地址可以转走自己多少个token
    function allowance(address _owner, address _spender) view returns (uint256 remaining);

    // 转账的时候必须要调用的事件，如transfer、transferFrom
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    // 成功执行approve方法后调用的事件
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}

contract MyToken is EIP20Interface {
    // 获取token名字，比如：“侯晓磊”
    string public name;
    // 获取token简称，比如：“HXL”
    string public symbol;
    // 获取小数位，比如以太坊的decimals为18；
    uint8 public decimals;
    // 获取token发布的总量，比如EOS 10亿
    uint256 public totalSupply;

    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowances;

    function MyToken(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;

        balances[msg.sender] = _totalSupply;
    }

    // 获取_owner地址的余额
    function balanceOf(address _owner) view returns (uint256 balance) {
        return balances[_owner];
    }

    // 转账：调用方向_to转_value个token
    function transfer(address _to, uint256 _value) returns (bool success) {
        require(_value > 0 && balances[_to] + _value > balances[_to] && balances[msg.sender] > _value);

        balances[_to] += _value;
        balances[msg.sender] -= _value;

        Transfer(msg.sender, _to, _value);
        return true;
    }

    // 转账：从_from向_to转_value个token
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        uint256 allowan = allowances[_from][_to];
        require(allowan >= _value && _value > 0 && balances[_from] >= _value
        && _to == msg.sender && balances[_to] + _value > balances[_to]);

        allowances[_from][_to] -= _value;
        balances[_from] -= _value;
        balances[_to] += _value;

        Transfer(_from, _to, _value);

        return true;
    }

    // 允许_spender从自己（调用方）账户转走_value个token
    function approve(address _spender, uint256 _value) returns (bool success) {
        require(_value > 0 && balances[msg.sender] > _value);

        //储存到allowances，自己msg.sender 允许_spender转走自己账户_value个token
        //自己可以多次调用，允许别人转走自己指定的金额
        //如果已经设置过了别人转走的金额，比如10，现在要求允许转走100，那么实际上它能转走多少呢？
        //根据token标准接口说明，指定重复调用要覆盖之前的值。
        allowances[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);

        return true;
    }

    // 自己（_owner）查询_spender地址可以转走自己多少个token
    function allowance(address _owner, address _spender) view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }
}
