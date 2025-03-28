[>>> Click here to open English version of this repository <<<](https://github.com/Antony-hash512/ArchLinuxMoneroMiner_install_scripts_english_version)

## Описание
Это узкоспециализированная инсталяция Arch Linux для майнига monero без ничего лишнего, предполагается, что блокчейн монеро закачан на другом разделе, который будет прописывается в fstab скриптом.
Если такового нет, то нужно изменить размер раздела с 10Gb до приемлемого
## Особенности
### Установочный скрипт
Данная версия скрипта предназначена для:
1) Установки системы на свежесозданный зашифрованный по паролю раздел внутри уже существующего не зашифрованного LVM
2) Для boot создаётся новый том, на уже существующем btrfs-разделе (при желании этот раздел может быть на съёмном носителе)
3) Установчный скрипт расчитан на пк с uefi.  (efi-раздел при желании тоже может быть на внешнем носителе)
Для более старых пк (например до 2012 года) с простым биосом скрипт требует небольшой модикации
4) Для установки с [официального iso-шника Arch](https://archlinux.org/download/) удобнее всего использовать флешку, созданную через утилиту [Ventoy](https://github.com/ventoy/Ventoy)
5) При использовании Ventoy, iso'шник Арча нужно закинуть на раздел с загрузочными образами, а данные скрипты на дополнительный раздел, который можно добавить на флешку при форматировании её Ventoy'ем
6) Данный скрипт можно использовать также если запустить из уже установленного Арча для установки в качестве второй системы дополнительно Арча без графической оболочки для майнига Монеро без лишних пакетов
### Система
* После установки, в системе будет использоваться утилита tmux, которая разделит консоль (голый TTY) на 4 части:
  * кошелёк monero
  * нода `p2pool`
  * майнер
  * `htop` для мониторинта загруженности системы
## Запуск:
Пара обязательных приготовлений перед запуском установки:

* Откройте скрипт в текстовом редакторе, отредактируйте значения переменных в начале скрипта в соответствии со своей системой. При желании и возможности ознакомтесь с тем, что именно он делает
* В разметке диска должны быть созданы:
  * группа томов LVM, в который будет добавлен новый логический том с системой внутри зашифрованного крипто-контейнера luks
  * раздел btrfs, для создания на нём подтома с бутом
### Установка
```bash
./INSTALL.sh
```
под рутом
### Запуск майнинга монеро
После установки:
```bash
~/temuxed_mnr_mining.sh
```
Файл [README-mining.md](README-mining.md) содержит справочную информацию по использовании утилиты `tmux`
### Интернет
* по проводу Ethernet интернет должен подрубиться автоматически
* для вайфая имеются следующие справочные readme:
  * [README-wifi-iwctl(iwd).md](README-wifi-iwctl(iwd).md) - подключение по вайфай из установочного iso
  * [README-wifi.md](README-wifi.md) - подключение по вайфай с помощью NetworkManager из уже установленной системы

