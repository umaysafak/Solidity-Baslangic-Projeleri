// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Oylama {

    struct Oy {
        address oyVeren;
        uint256 secim;
    }

    enum Secenek {Evet, Hayir}

    mapping(uint256 => Oy[]) private oylar;
    uint256 private oylamaSuresi;
    uint256 private baslangicZamani;
    uint256 private secenekSayisi;

    event OyVerildi(address indexed oyVeren, uint256 indexed secim);

    constructor(uint256 _oylamaSuresi, uint256 _secenekSayisi) {
        oylamaSuresi = _oylamaSuresi;
        baslangicZamani = block.timestamp;
        secenekSayisi = _secenekSayisi;
    }

    modifier oyKullanmaSuresiKontrol() {
        require(block.timestamp < baslangicZamani + oylamaSuresi, "Oylama suresi doldu");
        _;
    }

    function oyVer(uint256 _secim) public oyKullanmaSuresiKontrol {
        require(_secim < secenekSayisi, "Gecersiz secim");
        oylar[_secim].push(Oy(msg.sender, _secim));
        emit OyVerildi(msg.sender, _secim);
    }

    function oySayisi(uint256 _secim) public view returns (uint256) {
        require(_secim < secenekSayisi, "Gecersiz secim");
        return oylar[_secim].length;
    }
}

/*
Bu Akıllı Sözleşme Oylama projesi, Solidity dilinde bir oylama mekanizması oluşturur. Sözleşme içinde bir Oy adında bir yapı (struct) ve oylar adında bir mapping (eşleme) tanımlanır.

Oy yapısı, bir oy verenin adresini (oyVeren) ve seçiminin indeksini (secim) içerir. Bu yapı, her bir oy verme işlemini temsil eder.

oylar mapping'i, seçenek indekslerini Oy yapılarına eşler. Her bir seçenek için oy verenlerin oylarını depolar.

Sözleşme ayrıca oylamaSuresi, baslangicZamani ve secenekSayisi adında değişkenler içerir. oylamaSuresi değişkeni, oylamanın ne kadar süreceğini belirler.
baslangicZamani değişkeni, oylamanın başlama zamanını temsil eder. secenekSayisi değişkeni ise oylamadaki seçenek sayısını belirtir.

oyKullanmaSuresiKontrol isimli bir modifier, oy kullanma süresinin kontrolünü yapar. Bu modifier, oy verme işlemlerinin oylama süresi içinde gerçekleştirilmesini sağlar.

oyVer fonksiyonu, kullanıcının oy vermesini sağlar. Verilen oy, oylar mapping'ine ilgili seçenek indeksine göre kaydedilir.
Ayrıca, OyVerildi event'i tetiklenir.

oySayisi fonksiyonu, belirli bir seçeneğe verilen oyların sayısını döndürür.

Bu Akıllı Sözleşme Oylama projesi, kullanıcıların belirli bir süre boyunca oy kullanmalarını sağlar ve verilen oyları depolar.
Oylar, seçeneklerine göre ayrı ayrı kaydedilir ve oylama sonucunda istatistiksel analizler yapılabilir.
*/
