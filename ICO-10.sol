// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ICO {
    address public owner;                // Sözleşme sahibinin adresi
    address public token;                // Tokenin adresi
    uint256 public tokenPrice;           // Tokenin satış fiyatı
    uint256 public totalTokens;          // Toplam token miktarı
    uint256 public totalSold;            // Satılan token miktarı

    mapping(address => uint256) public balances;          // Kullanıcıların token bakiyelerini tutan mapping

    event TokenPurchased(address indexed buyer, uint256 amount, uint256 totalCost);

    constructor(address _tokenAddress, uint256 _tokenPrice, uint256 _totalTokens) {
        owner = msg.sender;                  // Sözleşme sahibi, sözleşme oluşturulduğunda msg.sender olarak atanır
        token = _tokenAddress;                // Tokenin adresi, sözleşme oluşturulduğunda belirtilen değer olarak atanır
        tokenPrice = _tokenPrice;             // Tokenin satış fiyatı, sözleşme oluşturulduğunda belirtilen değer olarak atanır
        totalTokens = _totalTokens;           // Toplam token miktarı, sözleşme oluşturulduğunda belirtilen değer olarak atanır
        totalSold = 0;
    }

    function buyTokens(uint256 _amount) external payable {
        require(_amount > 0, "Token amount must be greater than zero");
        require(totalSold + _amount <= totalTokens, "Insufficient tokens available for sale");

        uint256 cost = _amount * tokenPrice;
        require(msg.value >= cost, "Insufficient funds");

        balances[msg.sender] += _amount;
        totalSold += _amount;

        (bool success, ) = payable(owner).call{value: cost}("");
        require(success, "Payment failed");

        emit TokenPurchased(msg.sender, _amount, cost);
    }

    function withdrawTokens(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Insufficient token balance");

        balances[msg.sender] -= _amount;
        totalSold -= _amount;

        (bool success, ) = payable(msg.sender).call{value: _amount * tokenPrice}("");
        require(success, "Token withdrawal failed");
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}

/*
Bu sözleşme, bir ICO (Initial Coin Offering) olarak adlandırılan bir token satışı işlemini gerçekleştirmek için kullanılan bir Ethereum akıllı sözleşmesidir.
Aşağıda sözleşmenin ayrıntılı açıklaması bulunmaktadır:

owner: Sözleşme sahibinin Ethereum adresini temsil eden bir değişken. Sözleşme sahibi, sözleşmeyi oluşturan kişidir.

token: Tokenin Ethereum adresini temsil eden bir değişken. Bu adres, satışa sunulan tokenin yer aldığı akıllı sözleşmenin adresini gösterir.

tokenPrice: Tokenin satış fiyatını temsil eden bir değişken. Tokenin fiyatı, sözleşme oluşturulurken belirlenen değerdir.

totalTokens: Toplam token miktarını temsil eden bir değişken. Bu değer, sözleşme oluşturulurken belirlenen toplam token miktarını gösterir.

totalSold: Satılan token miktarını temsil eden bir değişken. Bu değer, satın alınan tokenlerin toplam miktarını gösterir.

balances: Kullanıcıların token bakiyelerini tutan bir mapping. Her kullanıcının Ethereum adresi, sahip olduğu token miktarına karşılık gelen bir değere bağlıdır.

TokenPurchased etkinliği: Token satın alındığında tetiklenen bir etkinlik. Bu etkinlik, satın alan kullanıcının adresini, satın alınan token miktarını ve toplam maliyeti içerir.

constructor: Sözleşme oluşturulduğunda çalışan bir işlev. Sözleşme sahibini, token adresini, token satış fiyatını ve toplam token miktarını belirtilen değerlere göre ayarlar.

buyTokens işlevi: Kullanıcıların token satın almasını sağlayan bir işlev. Kullanıcı, belirtilen miktarda token satın alabilir ve bu işlem için ödeme yapar.
Satın alma işlemi başarılıysa, kullanıcının bakiyesi güncellenir, satılan token miktarı artar ve ödeme sözleşme sahibine aktarılır.

withdrawTokens işlevi: Kullanıcıların sahip oldukları tokenleri geri çekmelerini sağlayan bir işlev. Kullanıcı, belirtilen miktarda tokeni geri çekebilir ve karşılığında ödeme alır.
Geri çekme işlemi başarılıysa, kullanıcının bakiyesi güncellenir ve ödeme kullanıcıya aktarılır.

getBalance işlevi: Kullanıcının token bakiyesini döndüren bir işlev. Kullanıcı, bu işlevi çağırarak kendi bakiyesini kontrol edebilir.

Bu sözleşme, bir ICO için temel işlevleri sağlar: kullanıcılar token satın alabilir, satın aldıkları tokenleri geri çekebilir ve bakiyelerini kontrol edebilirler.
Sözleşme sahibi, token satışlarından elde edilen ödemeleri alır ve kullanıcıların token bakiyelerini günceller.
*/
