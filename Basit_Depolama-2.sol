// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Depolama {
    struct Veri {
        string isim;
        uint deger;
    }

    mapping(uint => Veri) public veriler;
    uint public veriSayisi;

    function veriEkle(string memory _isim, uint _deger) public {
        veriler[veriSayisi] = Veri(_isim, _deger);
        veriSayisi++;
    }

    function veriGetir(uint _index) public view returns (string memory, uint) {
        require(_index < veriSayisi, "Gecersiz veri indeksi");
        Veri memory hedefVeri = veriler[_index];
        return (hedefVeri.isim, hedefVeri.deger);
    }
}

/*
Bu basit depolama projesi, Solidity dilinde bir akıllı sözleşme oluşturur. Sözleşme içinde bir Veri adında bir yapı (struct) ve veriler adında bir mapping (eşleme) tanımlanır.

Veri yapısı, bir veri kaydının iki özelliğini içerir: isim (string türünde) ve deger (uint türünde). Bu yapı, farklı verileri depolamak için kullanılır.

veriler mapping'i, veri indekslerini Veri yapılarına eşler. Her bir veri kaydının bir benzersiz indeksi vardır.

Sözleşme ayrıca veriSayisi adında bir değişken içerir. Bu değişken, mevcut veri sayısını takip etmek için kullanılır.

veriEkle fonksiyonu, kullanıcılara yeni bir veri kaydı eklemek için kullanılır. Bu fonksiyon, _isim ve _deger parametreleri aracılığıyla yeni bir Veri yapısı oluşturur ve veriler mapping'ine kaydeder.
Ayrıca veriSayisi değişkenini günceller.

veriGetir fonksiyonu, belirli bir veri indeksine sahip olan Veri yapısını geri döndürmek için kullanılır. Kullanıcılar, _index parametresini kullanarak istedikleri veri kaydını alabilirler.
Fonksiyon, veri indeksinin geçerliliğini kontrol eder ve mevcut indekse sahip olan Veri yapısını döndürür.

Bu karmaşık basit depolama projesi, Solidity dilinde daha fazla veri manipülasyonunu ve kontrolünü gösterir.
Kullanıcılar, veriEkle fonksiyonu aracılığıyla yeni veri kayıtları ekleyebilir ve veriGetir fonksiyonuyla kaydedilen verilere erişebilirler.
Bu tür bir depolama mekanizması, daha karmaşık akıllı sözleşmelerin geliştirilmesinde kullanılabilir ve veri yönetimi için farklı senaryoları destekleyebilir.
*/
