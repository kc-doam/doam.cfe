﻿////////////////////////////////////////////////////////////////////////////////
// Помощник отправить (клиент, переопределяемый):
//  Содержит переопределяемые процедуры и функции общ. модуля ПомощникОтправитьКлиент.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Вызывается из ПомощникОтправитьКлиент.ОтправитьПроцесс при отправке процесса.
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения - форма из которой инициирована отправка.
//  ТипыПроцессов - Массив, Строка, Неопределено - типы процессов в виде наименований процессов,
//                                                 доступные для выбора в помощнике.
//  СтандартнаяОбработка -  Булево - при установке Ложь стандартная логика отправки процесса
//                                   будет проигнорирована.
//
Процедура ПриОтправкеПроцесса(ФормаВладелец, ТипыПроцессов, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПомощникОтправитьКлиентКОРП.ОтправитьПроцесс(ФормаВладелец, ТипыПроцессов);
	
КонецПроцедуры

// Вызывается из ПомощникОтправитьКлиент.ОбработатьВыборВарианта при обработке выбора варианта.
//
// Параметры:
//  Вариант - Произвольный - вариант отправки.
//  Параметры - Структура - см. ПомощникОтправить.ПараметрыВарианта
//  ФормаВладелец - ФормаКлиентскогоПриложения - форма из которой инициирована обработка.
//  СтандартнаяОбработка - Булево - при установке Ложь стандартная логика обработки выбора варианта
//                                  будет проигнорирована.
//
Процедура ПриОбработкеВыбораВарианта(Вариант, Параметры, ФормаВладелец, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПомощникОтправитьКлиентКОРП.ОбработатьВыборВарианта(Вариант, Параметры, ФормаВладелец);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ВариантСоздатьПисьмоНаОсновании

// Вызывается из ПомощникОтправитьКлиент.ОтправитьПоВариантуСоздатьПисьмоНаОсновании
// при добавлении в дерево варианта создания письма.
//
// Параметры:
//  Параметры - Структура - параметры отправки.
//  СтандартнаяОбработка -  Булево - при установке Ложь стандартный алгоритм отправке по варианту
//                                   будет проигнорирован.
//
Процедура ПриОтправкеПоВариантуСоздатьПисьмоНаОсновании(Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПомощникОтправитьКлиентКОРП.ОтправитьПоВариантуСоздатьПисьмоНаОсновании(Параметры);
	
КонецПроцедуры

#КонецОбласти