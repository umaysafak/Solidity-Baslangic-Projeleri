// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ComplexERC20Token {
    // Tokenin ismi
    string public name;

    // Tokenin sembolü
    string public symbol;

    // Tokenin ondalık basamak sayısı
    uint8 public decimals;

    // Toplam token arzı
    uint256 public totalSupply;

    // Adreslerin bakiyelerini tutan harita
    mapping(address => uint256) public balanceOf;

    // Adresler arasındaki yetki miktarlarını tutan harita
    mapping(address => mapping(address => uint256)) public allowance;

    // Transfer olayı
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Yetkilendirme olayı
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Yakma olayı
    event Burn(address indexed from, uint256 value);

    // Sözleşme oluşturulduğunda çalışan constructor fonksiyonu
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;

        // Sözleşme sahibinin bakiyesini toplam arza eşitler
        balanceOf[msg.sender] = _totalSupply;
    }

    // Token transferi gerçekleştiren fonksiyon
    function transfer(address _to, uint256 _value) external returns (bool) {
        // Geçersiz alıcı adresi kontrolü
        require(_to != address(0), "Gecersiz alici adresi");

        // Gönderenin bakiyesinin yeterli olup olmadığı kontrolü
        require(_value <= balanceOf[msg.sender], "Yetersiz bakiye");

        // Gönderenin bakiyesinden düşme ve alıcının bakiyesine ekleme işlemi
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // Transfer olayını tetikleme
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    // Yetkilendirme işlemi gerçekleştiren fonksiyon
    function approve(address _spender, uint256 _value) external returns (bool) {
        // Yetkilendirme haritasında değeri güncelleme
        allowance[msg.sender][_spender] = _value;

        // Approval olayını tetikleme
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    // Yetkilendirilmiş transfer gerçekleştiren fonksiyon
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool) {
        // Geçersiz alıcı adresi kontrolü
        require(_to != address(0), "Gecersiz alici adresi");

        // Gönderenin yeterli bakiyeye sahip olup olmadığı kontrolü
        require(_value <= balanceOf[_from], "Yetersiz bakiye");

        // Yetkilendirme miktarının yeterli olup olmadığı kontrolü
        require(_value <= allowance[_from][msg.sender], "Yetersiz yetkilendirme");

        // Gönderenden düşme, alıcıya ekleme ve yetkilendirme miktarının düşürülmesi
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        // Transfer olayını tetikleme
        emit Transfer(_from, _to, _value);

        return true;
    }

    // Tokeni yakmayı gerçekleştiren fonksiyon
    function burn(uint256 _value) external returns (bool) {
        // Gönderenin yeterli bakiyeye sahip olup olmadığı kontrolü
        require(_value <= balanceOf[msg.sender], "Yetersiz bakiye");

        // Gönderenden düşme ve toplam arzın düşürülmesi
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;

        // Burn olayını tetikleme
        emit Burn(msg.sender, _value);

        return true;
    }
}

/*
Bu ERC-20 token sözleşmesi, token tabanlı bir ekosistemin temelini oluşturmak için kullanılabilir.
Sözleşme, tokenin ismini, sembolünü, ondalık basamak sayısını ve toplam arzını tutan değişkenlere sahiptir. 
yrıca, her kullanıcının bakiyesini ve yetkilendirme miktarlarını takip eden haritalar içerir.

Sözleşme, token transferlerini, yetkilendirme işlemlerini ve token yakma işlemlerini gerçekleştiren işlevlere sahiptir.
Bu işlevler, gönderenin yeterli bakiyeye ve yetkilendirmeye sahip olup olmadığını kontrol eder ve bakiyeleri günceller.
Transfer, Approval ve Burn olayları, token transferleri, yetkilendirme işlemleri ve token yakma işlemleri gibi olayların izlenmesini sağlar.

Bu ERC-20 token sözleşmesi, gelişmiş token tabanlı uygulamaların geliştirilmesine olanak tanır.
Farklı senaryolara uyum sağlamak için yetkilendirme işlemleri ve token yakma özelliği gibi ek fonksiyonlara sahiptir.
Bu sayede, daha karmaşık token tabanlı uygulamalar oluşturmak için kullanılabilir.
*/
