﻿

////////////////////////////////////////////////////////////////////////////////
// ОбменСКонтрагентамиКлиентПереопределяемый: механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область СобытияЭлектронныхДокументов

// Событие возникает непосредственно перед запуском формирования электронных документов, до запуска внутренних проверок.
// Позволяет выполнить дополнительные действия перед формированием электронных документов, в том числе отказаться от их формирования.
//
//Параметры:
// ОповещениеОЗавершении - ОписаниеОповещения - обработчик оповещения, который нужно вызвать после завершения
//                         обработки результатов проверок формирования электронных документов.
//   * Результат - Соответствие - коллекция ключей связи с данными электронных документов для отказа от записи.
//                                Данные, по которым не переданы ключи, считаются валидными и будут записаны.
//     ** Ключ - Число - ключ связи с данными для проверки
//                      (См. ОбменСКонтрагентамиПереопределяемый.ПриПроверкеФормированияДокументовЭДО).
//     ** Значение - Булево - признак отказа от записи данных электронного документа.
//                            Если Истина, то запись данных не выполняется.
// ПараметрыОбработки - Структура - параметры, переданные из процедуры
//                    см. ОбменСКонтрагентамиПереопределяемый.ПриОбработкеРезультатовПроверокФормированияДокументовЭДО
//
//@skip-warning
Процедура ПриОбработкеРезультатовПроверокФормированияДокументовЭДО(ОповещениеОЗавершении, ПараметрыОбработки) Экспорт
	
КонецПроцедуры

// Событие возникает непосредственно перед утверждением входящих электронных документов. Позволяет выполнить дополнительные
// действия перед утверждением электронных документов, в том числе отказаться от него.
//
//Параметры:
// ОповещениеОЗавершении - ОписаниеОповещения - обработчик оповещения, который нужно вызвать после завершения
//                         обработки результатов проверок формирования ответов по электронным документам.
//   * Результат - Соответствие - коллекция ключей связи с данными электронных документов для отказа от записи.
//                                Данные, по которым не переданы ключи, считаются валидными и будут записаны.
//     ** Ключ - Число - ключ связи с данными для проверки
//                      (См. ОбменСКонтрагентамиПереопределяемый.ПриПроверкеФормированияОтветовПоДокументамЭДО).
//     ** Значение - Булево - признак отказа от записи данных электронного документа.
//                            Если Истина, то запись данных не выполняется.
// ПараметрыОбработки - Структура - параметры, переданные из процедуры
//            см. ОбменСКонтрагентамиПереопределяемый.ПриОбработкеРезультатовПроверокФормированияОтветовПоДокументамЭДО
//
//@skip-warning
Процедура ПриОбработкеРезультатовПроверокФормированияОтветовПоДокументамЭДО(ОповещениеОЗавершении, ПараметрыОбработки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ВыборПрикладныхЗначений

// Открывает форму подбора номенклатуры с целью выбора позиций, помещаемых в формируемый электронный документ "Каталог товаров". 
//
// Параметры:
//  ИдентификаторФормы   - УникальныйИдентификатор - уникальный  идентификатор формы, вызвавшей функцию.
//  ОбработкаПродолжения - ОписаниеОповещения - обработчик необходимо вызывать после закрытия формы подбора.
//  					   В качестве результата в него необходимо передать адрес временного хранилища, содержащего
//  					   таблицу подобранных позиций номенклатуры. В дальнейшем эта таблица будет передана в метод
//  					   заполнения данных для каталога товаров. См. ОбменСКонтрагентамиПереопределяемый.ЗаполнитьДанныеПоКаталогуТоваровCML.
//  					   Если выполняется отмена операции, в обработчик должно быть передано Неопределено.
//
Процедура ОткрытьФормуПодбораТоваров(ИдентификаторФормы, ОбработкаПродолжения) Экспорт
	
КонецПроцедуры

// Выполняется при подборе (выборе) учетного документа.
// Позволяет отказаться от стандартного ввода значения, открыв необходимую форму.
//
// Параметры:
//  Настройки - Структура - настройки подбора учетного документа.
//   * ИмяОбъектаМетаданных - Строка - полное имя объекта метаданных для выбора.
//   * ИмяТипаСсылки - Строка - имя типа ссылки для выбора. Например, "ДокументСсылка.ПоступлениеТоваровУслуг".
//   * Контрагент - ОпределяемыйТип.УчастникЭДО - контрагент по электронному документу.
//   * Организация - ОпределяемыйТип.Организация - организация по электронному документу.
//  ОповещениеОВыборе - ОписаниеОповещения - оповещение, которое необходимо выполнить с результатом выбора пользователя.
//                                           Если пользователь отказался от выбора, то выполнить со значением Неопределено.
//  СтандартнаяОбработка - Булево - признак открытия стандартного выбора значения.
//                                  Если процедура переопределяется, то следует установить Ложь.
//
// Пример:
//  // Открываем форму выбора с установленным отбором по контрагенту и организации.
//  СтандартнаяОбработка = Ложь;
//  ПараметрыФормы = Новый Структура("РежимВыбора,ЗакрыватьПриВыборе", Истина, Истина);
//  Отбор = Новый Структура("Контрагент,Организация", Настройки.Контрагент, Настройки.Организация);
//  ПараметрыФормы.Вставить("Отбор", Отбор);
//  ОткрытьФорму(Настройки.ИмяОбъектаМетаданных + ".ФормаВыбора", ПараметрыФормы,,,,, ОповещениеОВыборе, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
//
Процедура ПриПодбореУчетногоДокумента(Знач Настройки, Знач ОповещениеОВыборе, СтандартнаяОбработка = Истина) Экспорт
	
КонецПроцедуры

// Открывает форму редактирования кода налогового органа, если он хранится в конфигурации
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - обработчик оповещения о завершении.
//  	В обработчик оповещения возвращается значение:
//			Неопределено - при нажатии пользователем кнопки Отмена;
//			Число        - Номер налогового органа, введенного пользователем
//  Организация - ОпределяемыйТип.Организация - Организация для которой редактируется код налогового органа.
//  СтандартнаяОбработка - Булево - признак открытия стандартного выбора значения.
//                         Если процедура переопределяется, то следует установить Ложь.
//
//@skip-warning
Процедура ПриЗаполненииНалоговогоОргана(ОповещениеОЗавершении, Организация, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Открывает форму выбора договора контрагента.
//
// Параметры:
//  Параметры - Структура - параметры формы.
//     * Организация - ОпределяемыйТип.Организация - ссылка на организацию.
//     * Контрагент  - ОпределяемыйТип.КонтрагентБЭД - ссылка на контрагента.
//  Владелец - УправляемаяФорма, ПолеФормы - форма или элемент управления другой формы.
//  ОповещениеОЗакрытии - ОписаниеОповещения - описание оповещения о закрытии, с которым нужно открыть форму.
//  СтандартнаяОбработка - Булево - признак открытия стандартного выбора значения.
//                         Если процедура переопределяется, то следует установить Ложь.
//
Процедура ПриВыбореДоговораКонтрагента(Параметры, Владелец, ОповещениеОЗакрытии, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Открывает форму создания нового контрагента с заполненными данными.
// 
// Параметры:
//  РеквизитыКонтрагента - Структура - источник заполнения реквизитов. Возможные элементы:
//   * Наименование - Строка
//   * ИНН - Строка
//   * КПП - Строка
//  ОписаниеОповещенияОСозданииКонтрагента - ОписаниеОповещения - (не является обработчиком оповещения о закрытии)
//   требуется вызвать данный обработчик со ссылкой на созданного контрагента в параметре Результат.
Процедура СоздатьКонтрагентаИнтерактивно(РеквизитыКонтрагента, ОписаниеОповещенияОСозданииКонтрагента) Экспорт
	
	СтруктураЗаполнения = Новый Структура;
	СтруктураЗаполнения.Вставить("Наименование", РеквизитыКонтрагента.Наименование);
	СтруктураЗаполнения.Вставить("НаименованиеПолное", РеквизитыКонтрагента.Наименование);
	СтруктураЗаполнения.Вставить("ИНН", РеквизитыКонтрагента.ИНН);
	СтруктураЗаполнения.Вставить("КПП", РеквизитыКонтрагента.КПП);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтруктураЗаполнения", СтруктураЗаполнения);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияОСозданииКонтрагента", ОписаниеОповещенияОСозданииКонтрагента);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения(Неопределено,, ДополнительныеПараметры);
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаЭлемента", ПараметрыФормы,,,,, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

// Открывает форму выбора контрагента с отбором.
// 
// Параметры:
//  РеквизитыОтбораКонтрагента - Структура - источник заполнения отбора списка контрагентов.
//   Возможные значения:
//   * Наименование - Строка
//   * ИНН - Строка
//   * КПП - Строка
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения. 
Процедура ВыбратьКонтрагента(РеквизитыОтбораКонтрагента, ОписаниеОповещенияОЗакрытии) Экспорт
	
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(РеквизитыОтбораКонтрагента.Наименование) Тогда
		Отбор.Вставить("Наименование", РеквизитыОтбораКонтрагента.Наименование);
	КонецЕсли;
	Если ЗначениеЗаполнено(РеквизитыОтбораКонтрагента.ИНН) Тогда
		Отбор.Вставить("ИНН", РеквизитыОтбораКонтрагента.ИНН);
	КонецЕсли;
	Если ЗначениеЗаполнено(РеквизитыОтбораКонтрагента.КПП) Тогда
		Отбор.Вставить("КПП", РеквизитыОтбораКонтрагента.КПП);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отбор);

	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаВыбора", ПараметрыФормы,,,,, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Проверяет на использование в прикладном решении библиотеки интернет поддержки пользователей.
//
// Параметры:
//  Использование - булево - признак использования библиотеки БИП.
//
Процедура ПроверитьИспользованиеИнтернетПоддержкаПользователей(Использование) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
