**`iwd`** (iNet wireless daemon) — это современная консольная утилита для управления Wi-Fi на Linux, которая может работать как альтернатива **`wpa_supplicant`**. Чтобы подключиться к Wi-Fi с помощью **iwd**, нужно выполнить несколько шагов чтобы подключиться к Wi-Fi с загрузочного iso-шника Арча где нет NetworkManger'а

### Шаги для подключения к Wi-Fi через **iwd**:

1. **Запуск службы iwd**:

   Сначала убедитесь, что служба **iwd** запущена:

   ```bash
   sudo systemctl start iwd
   ```

   Если вы хотите, чтобы служба запускалась автоматически при загрузке, активируйте её:

   ```bash
   sudo systemctl enable iwd
   ```

2. **Запуск утилиты `iwctl`**:

   Для подключения к Wi-Fi используется утилита **`iwctl`**, которая идёт вместе с **iwd**. Запустите её:

   ```bash
   sudo iwctl
   ```

   Внутри этого интерфейса вы будете вводить команды для управления подключениями Wi-Fi.

3. **Проверка доступных интерфейсов**:

   Чтобы увидеть список беспроводных интерфейсов, выполните команду:

   ```bash
   device list
   ```

   Вы увидите список доступных интерфейсов. Обычно это будет что-то вроде **`wlan0`**.

4. **Сканирование доступных сетей**:

   Теперь вы можете просканировать доступные Wi-Fi сети:

   ```bash
   station wlan0 scan
   ```

   (Замените **`wlan0`** на имя вашего интерфейса, если оно другое).

5. **Просмотр доступных сетей**:

   После сканирования вы можете увидеть список доступных сетей:

   ```bash
   station wlan0 get-networks
   ```

6. **Подключение к сети**:

   Чтобы подключиться к сети, выполните команду:

   ```bash
   station wlan0 connect <SSID>
   ```

   Замените **`<SSID>`** на имя Wi-Fi сети, к которой вы хотите подключиться. Если сеть защищена паролем, вам будет предложено ввести его.

7. **Проверка подключения**:

   После подключения вы можете проверить статус вашего подключения:

   ```bash
   station wlan0 show
   ```

   Если всё прошло успешно, вы увидите информацию о подключении.

8. **Выход из iwctl**:

   Чтобы выйти из утилиты **`iwctl`**, просто выполните:

   ```bash
   exit
   ```

### Настройка IP с помощью `dhclient` (если не используется NetworkManager или systemd-networkd):

Если **`NetworkManager`** или **`systemd-networkd`** не управляют сетевыми подключениями, вам может потребоваться вручную запросить IP-адрес через **DHCP**:

```bash
sudo dhclient wlan0
```

После этого должно быть назначено IP-адресное подключение.

### Дополнительные команды:

- **Отключение от сети**:

   Если вы хотите отключиться от текущей сети, используйте:

   ```bash
   station wlan0 disconnect
   ```

- **Просмотр текущих подключений**:

   Команда для просмотра состояния:

   ```bash
   station wlan0 show
   ```

### Установка **iwd** (если не установлена):

Если **iwd** не установлен, его можно установить через **pacman**:

```bash
sudo pacman -S iwd
```

### Резюме:

1. Запустите **iwd** и утилиту **iwctl**.
2. Используйте **iwctl** для сканирования доступных сетей и подключения.
3. Введите пароль, если сеть защищена.
4. Проверьте подключение, используя **station wlan0 show**.

Таким образом, вы можете подключиться к Wi-Fi из консоли, используя **iwd**.