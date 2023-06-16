// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EtherCuzdani {
    mapping(address => uint256) private bakiyeler;
    mapping(address => mapping(address => uint256)) private izinliBakiyeler;

    event TransferYapildi(address indexed gonderen, address indexed alici, uint256 miktar);
    event ParaYatirildi(address indexed kullanici, uint256 miktar);
    event ParaCekildi(address indexed kullanici, uint256 miktar);
    event YetkiVerildi(address indexed kullanici, uint256 miktar);
    event YetkiKaldirildi(address indexed kullanici);

    function bakiyeGoruntule() public view returns (uint256) {
        return bakiyeler[msg.sender];
    }

    function paraYatir() public payable {
        bakiyeler[msg.sender] += msg.value;
        emit ParaYatirildi(msg.sender, msg.value);
    }

    function paraCek(uint256 _miktar) public {
        require(bakiyeler[msg.sender] >= _miktar, "Yetersiz bakiye");
        bakiyeler[msg.sender] -= _miktar;
        payable(msg.sender).transfer(_miktar);
        emit ParaCekildi(msg.sender, _miktar);
    }

    function transferYap(address _alici, uint256 _miktar) public {
        require(bakiyeler[msg.sender] >= _miktar, "Yetersiz bakiye");
        bakiyeler[msg.sender] -= _miktar;
        bakiyeler[_alici] += _miktar;
        emit TransferYapildi(msg.sender, _alici, _miktar);
    }

    function yetkiVer(address _kullanici, uint256 _miktar) public {
        izinliBakiyeler[msg.sender][_kullanici] = _miktar;
        emit YetkiVerildi(_kullanici, _miktar);
    }

    function yetkiKaldir(address _kullanici) public {
        delete izinliBakiyeler[msg.sender][_kullanici];
        emit YetkiKaldirildi(_kullanici);
    }

    function transferYetkilisiYoluylaYap(address _gonderen, address _alici, uint256 _miktar) public {
        require(izinliBakiyeler[_gonderen][msg.sender] >= _miktar, "Yetkili transfer miktari yetersiz");
        izinliBakiyeler[_gonderen][msg.sender] -= _miktar;
        bakiyeler[_gonderen] -= _miktar;
        bakiyeler[_alici] += _miktar;
        emit TransferYapildi(_gonderen, _alici, _miktar);
    }
}

/*
Bu Ether Cüzdanı projesi, Solidity dilinde gelişmiş bir cüzdan işlevselliği sağlar. Sözleşme içerisinde bakiyeler ve izinliBakiyeler adında iki mapping (eşleme) tanımlanır.

bakiyeGoruntule fonksiyonu, kullanıcının cüzdan bakiyesini görüntüler.

paraYatir fonksiyonu, kullanıcının cüzdanına Ether yatırmasını sağlar. Yatırılan Ether miktarı, kullanıcının bakiyesine eklenir. ParaYatirildi event'i tetiklenir.

paraCek fonksiyonu, kullanıcının cüzdanından Ether çekmesini sağlar. Çekilmek istenen Ether miktarı, kullanıcının bakiyesinden düşülür ve kullanıcının adresine transfer edilir. ParaCekildi event'i tetiklenir.

transferYap fonksiyonu, kullanıcının başka bir adrese Ether transferi yapmasını sağlar.

yetkiVer fonksiyonu, kullanıcının başka bir kullanıcıya belirli bir miktar Ether transferi yetkisi vermesini sağlar. YetkiVerildi event'i tetiklenir.

yetkiKaldir fonksiyonu, kullanıcının başka bir kullanıcının transfer yetkisini kaldırmasını sağlar. YetkiKaldirildi event'i tetiklenir.

transferYetkilisiYoluylaYap fonksiyonu, kullanıcının bir başka kullanıcının adına yetki verilmiş şekilde Ether transferi yapmasını sağlar.
Bu işlem, sadece yetkilendirilmiş bir transfer yetkilisi tarafından gerçekleştirilebilir. TransferYapildi event'i tetiklenir.

Bu proje, kullanıcıların Ether depolamasını, çekmesini ve başkalarına transfer etmesini sağlarken, aynı zamanda yetki verme ve yetki kaldırma işlevselliği sunar.
Böylece, kullanıcılar belirli bir miktar Ether'i başka bir kullanıcıya yetkilendirerek transferlerini yönetebilirler.
*/
