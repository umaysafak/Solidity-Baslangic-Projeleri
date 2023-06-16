// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// ERC20Token arayüzü
interface ERC20Token {
    // Belirli bir miktarda tokenin belirtilen adrese transferini sağlar.
    function transfer(address _to, uint256 _value) external returns (bool);
    
    // Belirli bir adrese belirli bir miktarda yetkilendirme yapar.
    function approve(address _spender, uint256 _value) external returns (bool);
    
    // Belirli bir hesaptan belirli bir miktarda tokeni başka bir hesaba transfer eder.
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    
    // Belirli bir hesabın bakiyesini getirir.
    function balanceOf(address _owner) external view returns (uint256);
}

contract TokenWallet {
    // Sözleşmenin sahibinin adresi
    address public owner;
    
    // Tokenin ERC20Token arayüzüne referansı
    ERC20Token public token;

    // Transfer ve Approval olayları
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Constructor
    constructor(address _tokenAddress) {
        // Sözleşme sahibini ve kullanılacak tokenin adresini belirle
        owner = msg.sender;
        token = ERC20Token(_tokenAddress);
    }

    // Token transferi
    function transfer(address _to, uint256 _value) external returns (bool) {
        // Geçersiz alıcı adresi kontrolü
        require(_to != address(0), "Invalid recipient address");

        // Token transferi gerçekleştir
        bool success = token.transfer(_to, _value);
        require(success, "Token transfer failed");

        // Transfer olayını tetikle
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    // Yetkilendirme işlemi
    function approve(address _spender, uint256 _value) external returns (bool) {
        // Geçersiz harcama adresi kontrolü
        require(_spender != address(0), "Invalid spender address");

        // Yetkilendirme işlemini gerçekleştir
        bool success = token.approve(_spender, _value);
        require(success, "Approval failed");

        // Approval olayını tetikle
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    // transferFrom işlemi
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        // Geçersiz gönderici ve alıcı adresleri kontrolü
        require(_from != address(0), "Invalid sender address");
        require(_to != address(0), "Invalid recipient address");

        // transferFrom işlemini gerçekleştir
        bool success = token.transferFrom(_from, _to, _value);
        require(success, "Token transfer failed");

        // Transfer olayını tetikle
        emit Transfer(_from, _to, _value);

        return true;
    }

    // Cüzdan bakiyesini getirme
    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    // Token çekme işlemi
    function withdrawToken(address _to, uint256 _value) external returns (bool) {
        // Sadece sözleşme sahibi tarafından çağrılabilirlik kontrolü
        require(msg.sender == owner, "Only owner can call this function");

        // Token çekme işlemini gerçekleştir
        bool success = token.transfer(_to, _value);
        require(success, "Token transfer failed");

        // Transfer olayını tetikle
        emit Transfer(address(this), _to, _value);

        return true;
    }
}

/*
Yukarıdaki sözleşme, TokenWallet adında karmaşık bir Token cüzdanı sağlar. Bu sözleşme, ERC20Token arayüzüne dayanarak Token ile etkileşim sağlar.
Token transferleri, yetkilendirme işlemleri ve bakiye sorgulamalarını gerçekleştirebilir. Ayrıca, sözleşme sahibi belirli bir miktarda tokeni geri çekebilir.
*/
