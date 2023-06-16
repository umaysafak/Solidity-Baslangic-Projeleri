// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MultiSender {
    function send(address[] memory _recipients, uint256[] memory _amounts) external payable {
        require(_recipients.length == _amounts.length, "Recipient and amount count mismatch");

        uint256 totalAmount = 0;

        for (uint256 i = 0; i < _recipients.length; i++) {
            totalAmount += _amounts[i];
        }

        require(msg.value >= totalAmount, "Insufficient Ether sent");

        for (uint256 i = 0; i < _recipients.length; i++) {
            payable(_recipients[i]).transfer(_amounts[i]);
        }
    }
}

/*
Bu çoklu gönderme projesi, Solidity dilinde çoklu adreslere Ether göndermeyi sağlar. Sözleşme içerisinde send fonksiyonu tanımlanır.

send fonksiyonu, _recipients ve _amounts isimli iki dizi parametre alır. _recipients dizisi, gönderilecek adresleri içerir ve _amounts dizisi, her bir adrese gönderilecek Ether miktarlarını içerir.
İki dizi arasında bir eşleme bulunmalıdır, yani _recipients dizisindeki bir adres ile _amounts dizisindeki bir miktar arasında bir ilişki olmalıdır.

Fonksiyon, _recipients dizisinin uzunluğu ile _amounts dizisinin uzunluğunu kontrol eder ve eşleme sayısının eşit olduğunu doğrular. Ardından, toplam gönderilecek Ether miktarını hesaplamak için bir döngü kullanır.

msg.value ifadesi, çağrı yapan adresin gönderdiği Ether miktarını temsil eder. msg.value değeri, toplam gönderilecek Ether miktarından büyük veya eşit olmalıdır, aksi takdirde işlem hata verecektir.

Son olarak, bir döngü kullanarak her bir alıcı adresine belirtilen miktarda Ether gönderilir. payable anahtar kelimesi, alıcı adresinin Ether alabilen bir adres olduğunu belirtir.

Bu proje, göndericinin toplu olarak farklı adreslere Ether göndermesini sağlar ve gönderilen Ether miktarını kontrol eder.
*/
