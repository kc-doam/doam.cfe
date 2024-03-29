| Расширение      | Конфигурация           | Платформа 
| :---            | :---                   | :--- 
| Расширение ДОАМ | Документооборот 8 КОРП | 1С:Предприятие 8.3 
| 1.4.2           | 2.1.29.17              | 8.3.22.1750 

### Краткое описание

Расширение добавляет в конфигурацию 1С:Документооборот 8 функционал для 
всестороннего поиска контрагентов ДОАМ, поскольку базовый функционал работы 
с контрагентами в данной конфигурации очень скудный.  
Расширение ДОАМ включает поля множественного выбора и панель отбора записей по 
всем полям контрагента (включая дополнительные реквизиты).

### Назначение расширения: Адаптация

- [x] Конфигурация находится на поддержке с возможностью изменения
- :mag: Объект расширяемой конфигурации

---
<details>
<summary>:black_square_button: Общие</summary><br />
  
  - Подсистемы (Subsystems)  
    - [x] ДОАМ [+Командный интерфейс]
  - Общие модули (CommonModules)  
    - [x] ОбщийДОАМ [+]  
    - [ ] ОбщийДОАМКлиентСервер
  - Роли (Roles)  
    - [x] ДобавлениеИзменениеКонтрагентов :mag: [+Права]
  - Функциональные опции (FunctionalOptions)  
    - [x] ВестиУчетФактическихТрудозатрат  
    - [x] ДокументооборотИспользоватьОграничениеПравДоступа  
    - [x] ИспользоватьБизнесПроцессыИЗадачи  
    - [x] ИспользоватьДополнительныеРеквизитыИСведения
  - Общие команды (CommonCommands)  
    - [x] СоздатьПисьмоНаОсновании  
    - [x] ДополнительныеСведенияКоманднаяПанель  
    - [x] СозданиеСвязанныхОбъектов  
    - [x] СоздатьПроцесс :mag:
  - Общие картинки (CommonPictures)  
    - [x] ДобавитьВОтчет  
    - [x] ЗаполнитьФорму  
    - [x] ПиктограммыЭлементов
  - Элементы стиля (StyleItems)  
    - [x] ТекстНевыбраннойКартинкиЦвет  
    - [x] ФонУправляющегоПоля

</details>
<details>
<summary>:black_square_button: Константы (Constants)</summary><br />

  - [x] ИспользоватьБизнесПроцессыИЗадачи  
  - [x] БанковскиеСчета  
  - [x] ЗначенияСвойствОбъектовИерархия

</details>
<details>
<summary>:black_square_button: Справочники (Catalogs)</summary><br />

  - [x] Контрагенты  
  - [x] КонтактныеЛица  
  - [x] БанковскиеСчета  
  - [x] Контроль  
  - [x] Мероприятия  
  - [x] ФизическиеЛица  
  - [x] Пользователи  
  - [x] ГруппыДоступаКонтрагентов  
  - [x] ЗаписиРабочегоКалендаря  
  - [x] НаборыДополнительныхРеквизитовИСведений  
  - [x] ЗначенияСвойствОбъектовИерархия  
  - [x] ЗначенияСвойствОбъектов  
  - [x] Организации  
  - [x] Валюты  
  - [x] КлассификаторБанков

</details>
<details>
<summary>:black_square_button: Перечисления (Enums)</summary><br />

  - [x] СпособыУказанияВремени  
  - [x] ЮрФизЛицо  
  - [x] СтадииВзаимодействия  
  - [x] ТипыКонтролирующихОрганов

</details>
<details>
<summary>:black_square_button: Обработки (DataProcessors)</summary><br />

  - [ ] РасшДОАМ_СписокКонтрагентов

</details>
<details>
<summary>:black_square_button: Планы видов характеристик (ChartsOfCharacteristicTypes)</summary><br />
  
  - [x] ДополнительныеРеквизитыИСведения
  
</details>
<details>
<summary>:black_square_button: Регистры сведений (InformationRegisters)</summary><br />
  
  - [x] ДокументыФизическихЛиц :mag: [+Модуль менеджера]
  
</details>

---
# Актуальные ссылки

1. [Стек технологий для 1С](//github.com/Oxotka/StackTechnologies1C)
2. [О выпуске программного продукта "1С:Документооборот 8 КОРП"](//1c.ru/news/info.jsp?id=12846)
3. [Новые возможности расширений в платформе 8.3.18](//курсы-по-1с.рф/news/2021-02-02-abilities-of-extentions-8-3-18/)
4. [Как обновить 1С:Документооборот КОРП](//efsol.ru/manuals/1cdo-update.html)
5. [1С Документооборот 2.1 Самоучитель](//www.youtube.com/playlist?list=PLUoO8d_m0O70dLKgwqeOWjQ9k5NBuuVP-)
6. [Расширения в 1С (курс)](//www.youtube.com/watch?v=McEeEtS32ms&list=PLh28ogpgRJUM702dP8f8JxOaf0vOK0IoL)

# Дополнительные ссылки

1. [Расширения конфигураций 1С: учимся перехватывать методы](//v8book.ru/public/628422/)
2. [Поиск "Document Management"](//edt.1c.ru/search/?q=Document+Management&where=edt)
3. [Вопросы администрирования](//www.1c-kpd.ru/knowledge/voprosy-administrirovaniya/) 
   [[?](//its.1c.ru/db/doccorp21/content/789/1/issogl2_добавлять_руководителям_доступ_подчиненных)]
4. [Ускорение медленной работы строк в 1С](//expert.chistov.pro/1c/articles/1303356/)
