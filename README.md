# ripper-wrapper
1. Можна запускати без параметрів (для першого запуску) - автоматом ставить `runmode=install і amount=50`
2. Додано параметр для конфігурування кількості контейнкрів - наприклад `/bin/bash os_x_ripper.sh -n 10`


## Актуальні команди:
`$your_os_file`:
 - Ubuntu/Debian familly: ubuntu_ripper.sh - gри першому запуску встановлює всі залежності
 - Mac OS: os_x_ripper.sh

1. Перший запуск:  
   `/bin/bash $your_os_file -n 10`  
   число можна не ставити якщо потужна машина
2. Апдейт існуючого:  
   `/bin/bash $your_os_file -m reinstall -n 10`  
   теж можна міняти кількість контейнерів якщо відчуваєте що машина тупить
3. Зупинка атаки:  
   `/bin/bash y$our_os_file -m stop`  
   наприклад якщо треба подзвонити кудись з відео
4. Продовження атаки:
   `/bin/bash $your_os_file -m start`