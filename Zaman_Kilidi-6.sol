// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TimeLock {
    struct Lock {
        uint256 releaseTime;
        uint256 lockAmount;
        bool released;
    }

    mapping(address => Lock) public locks;

    event LockCreated(address indexed beneficiary, uint256 releaseTime, uint256 lockAmount);
    event LockReleased(address indexed beneficiary, uint256 amount);

    function createLock(address beneficiary, uint256 releaseTime, uint256 lockAmount) external payable {
        require(releaseTime > block.timestamp, "Release time must be in the future");
        require(lockAmount > 0, "Lock amount must be greater than zero");

        Lock storage newLock = locks[beneficiary];
        require(!newLock.released, "Lock already released");

        newLock.releaseTime = releaseTime;
        newLock.lockAmount = lockAmount;
        newLock.released = false;

        emit LockCreated(beneficiary, releaseTime, lockAmount);
    }

    function releaseLock() external {
        Lock storage userLock = locks[msg.sender];
        require(!userLock.released, "Lock already released");
        require(block.timestamp >= userLock.releaseTime, "Release time has not yet arrived");

        uint256 amount = userLock.lockAmount;
        userLock.released = true;

        emit LockReleased(msg.sender, amount);

        payable(msg.sender).transfer(amount);
    }
}

/*
Bu Zaman Kilidi Akıllı Sözleşmesi aşağıdaki özellikleri içerir:

Lock yapısı: Yeni bir kilidi temsil eden releaseTime (serbest bırakma zamanı), lockAmount (kilitli miktar) ve released (serbest bırakıldı mı?) alanlarını içerir.
locks haritası: Her kullanıcının adresini kilide bağlayan bir harita. Her kullanıcının yalnızca bir kilidi olabilir.
LockCreated olayı: Yeni bir kilidin oluşturulduğunda tetiklenir ve ilgili bilgileri kaydeder.
LockReleased olayı: Bir kilidin serbest bırakıldığında tetiklenir ve ilgili bilgileri kaydeder.
Sözleşme aşağıdaki işlevleri içerir:

createLock işlevi: Yeni bir kilidin oluşturulmasını sağlar. Beneficiary (yararlanıcı), releaseTime (serbest bırakma zamanı) ve lockAmount (kilitli miktar) parametrelerini alır.
Bu işlev, haritaya yeni bir kilidi ekler ve LockCreated olayını tetikler.
releaseLock işlevi: Bir kullanıcının kilidini serbest bırakır. Kullanıcı tarafından kilidi açılmamış bir kilide sahip olması ve serbest bırakma zamanının gelmesi gerekmektedir.
Kilidin serbest bırakıldığını işaretler, LockReleased olayını tetikler ve kilitli miktarı kullanıcının adresine transfer eder.
*/
