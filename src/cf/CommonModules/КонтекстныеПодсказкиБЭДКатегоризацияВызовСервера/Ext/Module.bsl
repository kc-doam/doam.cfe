﻿////////////////////////////////////////////////////////////////////////////////
// КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера: механизм контекстных подсказок.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПолучениеКатегорий

// Возвращает ссылку на категорию "Вид электронного документа".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_ВидЭлектронногоДокумента() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_EDKind");
КонецФункции

// Возвращает ссылку на категорию "Для организации существует доступный сертификат".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_ДляОрганизацииСуществуетДоступныйСертификат() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_OrgAvlSertExist");
КонецФункции

// Возвращает ссылку на категорию "Код оператора контрагента".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_ОператорАбонента() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_CustomerOperCode");
КонецФункции

// Возвращает ссылку на категорию "Код оператора учетной записи организации".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_КодОператораУчетнойЗаписиОрганизации() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_OrgLoginOfOper");
КонецФункции

// Возвращает ссылку на категорию "Контрагент подключен к ЭДО".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_КонтрагентПодключенКЭДО() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_CustConected");
КонецФункции

// Возвращает ссылку на категорию "Связь организации с контрагентом настроена".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_СвязьОрганизацииСКонтрагентомНастроена() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_CustSettingsExis");
КонецФункции

// Возвращает ссылку на категорию "Направление ЭД".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_НаправлениеЭД() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_DocDirection");
КонецФункции

// Возвращает ссылку на категорию "Статус документооборота".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_СтатусДокументооборота() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_DocExchSts");
КонецФункции

// Возвращает ссылку на категорию "Тип электронного документа".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_ТипЭлектронногоДокумента() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_EDType");
КонецФункции

// Возвращает ссылку на категорию "Статус отражения ЭД в учете".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_СтатусОтраженияЭДВУчете() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_DocAccSts");
КонецФункции

// Возвращает ссылку на категорию "Существуют неверные подписи файла".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_СуществуютНеверныеПодписиФайла() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_SignIsNotRight");
КонецФункции

// Возвращает ссылку на категорию "Для организации существует учетная запись ЭДО".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_ДляОрганизацииСуществуетУчетнаяЗаписьЭДО() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_OrgLoginExist");
КонецФункции

// Возвращает ссылку на категорию "Электронный документ создан".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_ЭлектронныйДокументСоздан() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_EDExist");
КонецФункции

// Возвращает ссылку на категорию "Существуют сертификаты с истекающим сроком действия для организации".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция Категория_СуществуютСертификатыСИстекающимСрокомДействияДляОрганизации() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_AdHockOrgCertEx");
КонецФункции

// Возвращает ссылку на категорию "Существуют сертификаты с истекшим сроком действия для организации".
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
//
Функция Категория_СуществуютСертификатыСИстекшимСрокомДействияДляОрганизации() Экспорт
	Возврат КонтекстныеПодсказкиБЭДПовтИсп.КатегорияПоКоду("LED_ExpOrgCertExist");
КонецФункции

#КонецОбласти

#КонецОбласти
