// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Airdrop {
    address public owner;                       // Sözleşme sahibinin adresi
    uint256 public totalTokens;                  // Toplam token miktarı
    mapping(address => uint256) public airdropTokens;      // Her adresin alacağı token miktarını tutan mapping
    mapping(address => bool) public hasClaimed;             // Her adresin tokenleri talep edip etmediğini tutan mapping

    event AirdropTokensDistributed(address indexed recipient, uint256 amount);       // Tokenlerin dağıtıldığı zaman tetiklenen etkinlik
    event AirdropTokensClaimed(address indexed recipient, uint256 amount);           // Tokenlerin talep edildiği zaman tetiklenen etkinlik

    constructor(uint256 _totalTokens) {
        owner = msg.sender;                      // Sözleşme sahibi, sözleşme oluşturulduğunda msg.sender olarak atanır
        totalTokens = _totalTokens;               // Toplam token miktarı, sözleşme oluşturulduğunda belirtilen değer olarak atanır
    }

    function distributeTokens(address[] calldata _recipients, uint256[] calldata _amounts) external {
        require(msg.sender == owner, "Only the owner can distribute tokens");          // Sadece sözleşme sahibi token dağıtabilir
        require(_recipients.length == _amounts.length, "Recipient and amount count mismatch");     // Adres ve miktar sayıları eşleşmeli

        uint256 totalAmount = 0;

        for (uint256 i = 0; i < _recipients.length; i++) {
            require(!hasClaimed[_recipients[i]], "Recipient has already claimed tokens");   // Alıcılar daha önce token talep etmemiş olmalı

            airdropTokens[_recipients[i]] = _amounts[i];     // Alıcının token miktarını kaydet
            totalAmount += _amounts[i];                       // Toplam dağıtılan token miktarını güncelle

            emit AirdropTokensDistributed(_recipients[i], _amounts[i]);      // Dağıtım işlemi için etkinlik tetikle
        }

        require(totalAmount <= totalTokens, "Insufficient tokens for distribution");   // Dağıtım için yeterli token olmalı
        totalTokens -= totalAmount;                            // Dağıtılan tokenleri toplam token miktarından düş
    }

    function claimTokens() external {
        require(airdropTokens[msg.sender] > 0, "No tokens available for claim");           // Talep edilecek token olmalı
        require(!hasClaimed[msg.sender], "Tokens have already been claimed");               // Tokenler daha önce talep edilmemiş olmalı

        uint256 amount = airdropTokens[msg.sender];                    // Talep edilen token miktarını al
        airdropTokens[msg.sender] = 0;                                 // Talep edilen token miktarını sıfırla
        hasClaimed[msg.sender] = true;                                  // Tokenlerin talep edildiğini işaretle
        totalTokens -= amount;                                          // Toplam token miktarından talep edilen miktarı düş

        emit AirdropTokensClaimed(msg.sender, amount);                   // Token talep işlemi için etkinlik tetikle
    }
}

/*
Yukarıdaki sözleşme, karmaşık bir Airdrop projesini temsil etmektedir. Bu sözleşme, bir sözleşme sahibinin belirli bir miktar tokeni belirli adreslere dağıtmasını ve kullanıcıların bu tokenleri talep etmelerini sağlar.

Sözleşmenin temel işlevleri şunlardır:

distributeTokens: Sadece sözleşme sahibi tarafından çağrılan bir işlevdir ve belirli bir adrese belirli miktarda token dağıtır.
Dağıtım işlemi, _recipients ve _amounts dizileri aracılığıyla gerçekleştirilir. Dağıtım işlemi sırasında, her alıcının token miktarı _recipients ve _amounts dizilerindeki ilgili indekslere kaydedilir.
Ayrıca, toplam token miktarı güncellenir ve her dağıtım işlemi için AirdropTokensDistributed etkinliği tetiklenir.

claimTokens: Kullanıcıların tokenleri talep etmelerini sağlayan bir işlevdir. Kullanıcıların talep edebilmesi için önceden belirlenmiş bir token miktarına sahip olmaları gerekir.
Bu işlev, kullanıcının airdropTokens mapping'inde kaydedilen token miktarını sıfırlar ve hasClaimed mapping'ini günceller.
Ayrıca, toplam token miktarından talep edilen miktarı düşer ve her talep işlemi için AirdropTokensClaimed etkinliği tetiklenir.

Bu şekilde, karmaşık bir Airdrop projesini temsil eden Solidity sözleşmesi sağlanmıştır. Bu sözleşme, belirli adreslere token dağıtabilir ve kullanıcıların bu tokenleri talep etmelerine izin verir.
*/
