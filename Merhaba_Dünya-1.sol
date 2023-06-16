// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MerhabaDunya {
    string public mesaj;

    constructor() {
        mesaj = "Merhaba, Dunya!";
    }

    function setMesaj(string memory _yeniMesaj) public {
        mesaj = _yeniMesaj;
    }

    function getMesaj() public view returns (string memory) {
        return mesaj;
    }
}

/*
Bu basit "Merhaba, Dünya!" projesi, Solidity dilinde bir akıllı sözleşme oluşturur. Sözleşme içinde bir mesaj adında bir değişken tanımlanır ve başlangıç değeri olarak "Merhaba, Dünya!" atanır.

Sözleşme ayrıca setMesaj ve getMesaj fonksiyonlarına sahiptir. setMesaj fonksiyonu, _yeniMesaj parametresi aracılığıyla mesaj değişkeninin değerini güncellemek için kullanılır.
getMesaj fonksiyonu ise mesaj değişkeninin değerini okumak için kullanılır.

Bu sözleşme, dağıtıldığında "Merhaba, Dünya!" mesajını varsayılan olarak döndürür. Ancak setMesaj fonksiyonu aracılığıyla kullanıcılar mesajı istedikleri şekilde güncelleyebilirler.
getMesaj fonksiyonu, mevcut mesajı okumak için kullanılabilir.

Bu proje, Solidity dilini öğrenmek için temel bir örnektir ve akıllı sözleşme oluşturmanın temel prensiplerini gösterir.
*/
