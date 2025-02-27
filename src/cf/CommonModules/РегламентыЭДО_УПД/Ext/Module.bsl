﻿//@strict-types

#Область СлужебныеПроцедурыИФункции

#Область ДляВызоваИзМодуляРегламентыЭДО

// Возвращает состояние входящего электронного документа.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияДокументовЭДО
//
Функция СостояниеВходящегоДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента) Экспорт
	
	Состояние = Перечисления.СостоянияДокументовЭДО.ПустаяСсылка();
	
	Если ЗаполнитьСостояниеПоИсходящемуОтклонению(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
		ИЛИ ЗаполнитьСостояниеПоПредложениюОбАннулировании(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоВходящейИнформацииОтправителя(СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоИсходящейИнформацииПолучателя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоИсходящемуИзвещениюОПолучении(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоПодтверждениюОператора(ПараметрыДокумента,СостоянияЭлементовРегламента,
			Перечисления.ТипыЭлементовРегламентаЭДО.ПДО,
			Перечисления.ТипыЭлементовРегламентаЭДО.ПДО_ИОП, Состояние)
		
		ИЛИ ПараметрыДокумента.ТребуетсяПодтверждение
			И ЗаполнитьСостояниеПоПодтверждениюОператора(ПараметрыДокумента, СостоянияЭлементовРегламента,
				Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ПДП,
				Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ПДП_ИОП, Состояние)
		
		ИЛИ ПараметрыДокумента.ТребуетсяИзвещение
			И ЗаполнитьСостояниеПоПодтверждениюОператора(ПараметрыДокумента, СостоянияЭлементовРегламента,
				Перечисления.ТипыЭлементовРегламентаЭДО.ИОП_ПДП,
				Перечисления.ТипыЭлементовРегламентаЭДО.ИОП_ПДП_ИОП, Состояние)
		
		ИЛИ ЗначениеЗаполнено(Состояние) Тогда
		
		Возврат Состояние;
		
	ИначеЕсли ПараметрыДокумента.Исправлен Тогда
		
		Возврат Перечисления.СостоянияДокументовЭДО.ОбменЗавершенСИсправлением;
		
	КонецЕсли;
	
	Возврат Перечисления.СостоянияДокументовЭДО.ОбменЗавершен;
	
КонецФункции

// Возвращает состояние исходящего электронного документа.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияДокументовЭДО
//
Функция СостояниеИсходящегоДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента) Экспорт
	
	Состояние = Перечисления.СостоянияДокументовЭДО.ПустаяСсылка();
	
	Если ЗаполнитьСостояниеПоИсходящейИнформацииОтправителя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоПредложениюОбАннулировании(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоВходящемуОтклонению(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоПодтверждениюОператора(ПараметрыДокумента, СостоянияЭлементовРегламента,
			Перечисления.ТипыЭлементовРегламентаЭДО.ПДП,
			Перечисления.ТипыЭлементовРегламентаЭДО.ПДП_ИОП, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоВходящемуИзвещениюОПолучении(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоВходящейИнформацииПолучателя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗначениеЗаполнено(Состояние) Тогда
		
		Возврат Состояние;
		
	ИначеЕсли ПараметрыДокумента.Исправлен Тогда
		
		Возврат Перечисления.СостоянияДокументовЭДО.ОбменЗавершенСИсправлением;
		
	КонецЕсли;
	
	Возврат Перечисления.СостоянияДокументовЭДО.ОбменЗавершен;
	
КонецФункции

// Возвращает состояние сообщения.
//
// Параметры:
//  ПараметрыСообщения - См. РегламентыЭДО.НовыеПараметрыСообщенияДляОпределенияСостояния
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостоянияСообщения
//  ИспользоватьУтверждение  - Булево
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияСообщенийЭДО
//
Функция СостояниеСообщения(ПараметрыСообщения, ПараметрыДокумента, ИспользоватьУтверждение) Экспорт
	
	Если ПараметрыСообщения.ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПОА Тогда
		Состояние = РегламентыЭДО.СостояниеСообщенияАннулирования(ПараметрыСообщения, ПараметрыДокумента);
	ИначеЕсли РегламентыЭДО.ЭтоСлужебноеСообщение(ПараметрыСообщения.ТипЭлементаРегламента) Тогда
		Состояние = РегламентыЭДО.СостояниеСлужебногоСообщения(ПараметрыСообщения, ПараметрыДокумента);
	Иначе
		Состояние = РегламентыЭДО.СостояниеСообщенияФНС(ПараметрыСообщения, ПараметрыДокумента, ИспользоватьУтверждение);
	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

// Возвращает коллекцию добавленных элементов схемы регламента.
// 
// Параметры:
//  СхемаРегламента - См. РегламентыЭДО.НоваяСхемаРегламента
//  НастройкиСхемыРегламента - См. РегламентыЭДО.НовыеНастройкиСхемыРегламента
//
// Возвращаемое значение:
//  См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
//
Функция ДобавитьЭлементыСхемыРегламента(СхемаРегламента, НастройкиСхемыРегламента) Экспорт
	
	ЭлементыСхемы = РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента();
	
	Если НастройкиСхемыРегламента.ЭтоВходящийЭДО Тогда
		ДобавитьЭлементыРегламентаПолучателя(СхемаРегламента, НастройкиСхемыРегламента, ЭлементыСхемы);
	Иначе
		ДобавитьЭлементыРегламентаОтправителя(СхемаРегламента, НастройкиСхемыРегламента, ЭлементыСхемы);
	КонецЕсли;
	
	ДобавитьЭлементыРегламентаАннулирования(ЭлементыСхемы);
	
	ДобавитьЭлементыРегламентаОтклонения(ЭлементыСхемы, НастройкиСхемыРегламента.ЭтоВходящийЭДО);
	
	Возврат ЭлементыСхемы;
	
КонецФункции

// Возвращает тип извещения для элемента входящего документа.
// 
// Параметры:
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
Функция ТипИзвещенияДляЭлементаВходящегоДокумента(ТипЭлементаРегламента) Экспорт
	Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ПустаяСсылка();
	Если ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя Тогда
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ИОП;
	ИначеЕсли ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПДО Тогда
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ПДО_ИОП;
	ИначеЕсли ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИОП_ПДП Тогда
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ИОП_ПДП_ИОП;
	ИначеЕсли ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ПДП Тогда
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ПДП_ИОП;
	ИначеЕсли ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.УОУ Тогда
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.УОУ_ИОП;
	КонецЕсли;
	Возврат Результат;
КонецФункции

// Возвращает тип извещения для элемента исходящего документа.
// 
// Параметры:
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
Функция ТипИзвещенияДляЭлементаИсходящегоДокумента(ТипЭлементаРегламента) Экспорт
	Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ПустаяСсылка();
	Если ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПДП Тогда
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ПДП_ИОП;
	ИначеЕсли ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.УОУ Тогда
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.УОУ_ИОП;
	КонецЕсли;
	Возврат Результат;
КонецФункции

// Возвращает признак наличия информации получателя в регламенте.
// 
// Возвращаемое значение:
//  Булево
//
Функция ЕстьИнформацияПолучателя() Экспорт
	Возврат Истина;
КонецФункции

#КонецОбласти

#Область ДобавитьЭлементыСхемыРегламента

// Добавляет элементы по регламенту отправителя.
// 
// Параметры:
//  СхемаРегламента - См. РегламентыЭДО.НоваяСхемаРегламента
//  НастройкиСхемыРегламента - См. РегламентыЭДО.НовыеНастройкиСхемыРегламента
//  ЭлементыСхемы - См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
//
Процедура ДобавитьЭлементыРегламентаОтправителя(СхемаРегламента, НастройкиСхемыРегламента, ЭлементыСхемы)
	
	ИнформацияОтправителя = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, СхемаРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя);
	
	Если РегламентыЭДО.ЭтоОбменЧерезОператора(НастройкиСхемыРегламента.СпособОбмена) Тогда
		
		ПДП = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
			Перечисления.ТипыЭлементовРегламентаЭДО.ПДП);
		
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ПДП,
			Перечисления.ТипыЭлементовРегламентаЭДО.ПДП_ИОП);
		
	КонецЕсли;
		
	ИОП = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИОП,
		Не НастройкиСхемыРегламента.ТребуетсяИзвещение);
		
	РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИОП,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИОП_ПДО);
	
	ИнформацияПолучателя = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя,
		Не НастройкиСхемыРегламента.ТребуетсяПодтверждение);
		
	РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияПолучателя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ПДО);
	
КонецПроцедуры

// Добавляет элементы по регламенту получателя.
// 
// Параметры:
//  СхемаРегламента - См. РегламентыЭДО.НоваяСхемаРегламента
//  НастройкиСхемыРегламента - См. РегламентыЭДО.НовыеНастройкиСхемыРегламента
//  ЭлементыСхемы - См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
//
Процедура ДобавитьЭлементыРегламентаПолучателя(СхемаРегламента, НастройкиСхемыРегламента, ЭлементыСхемы)
	
	ЭтоОбменЧерезОператора = РегламентыЭДО.ЭтоОбменЧерезОператора(НастройкиСхемыРегламента.СпособОбмена);
	
	ИнформацияОтправителя = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, СхемаРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя);
	
	Если ЭтоОбменЧерезОператора Тогда
		
		ПДО = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
			Перечисления.ТипыЭлементовРегламентаЭДО.ПДО);
		
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ПДО,
			Перечисления.ТипыЭлементовРегламентаЭДО.ПДО_ИОП);
		
	КонецЕсли;
	
	ИОП = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИОП,
		Не НастройкиСхемыРегламента.ТребуетсяИзвещение);
	
	Если ЭтоОбменЧерезОператора Тогда
		
		ИОП_ПДО = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИОП,
			Перечисления.ТипыЭлементовРегламентаЭДО.ИОП_ПДП);
		
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИОП_ПДО,
			Перечисления.ТипыЭлементовРегламентаЭДО.ИОП_ПДП_ИОП);
		
	КонецЕсли;
	
	ИнформацияПолучателя = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя,
		Не НастройкиСхемыРегламента.ТребуетсяПодтверждение);
	
	Если ЭтоОбменЧерезОператора Тогда
		
		ИП_ПДО = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияПолучателя,
			Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ПДП);
		
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИП_ПДО,
			Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ПДП_ИОП);
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет элементы по регламенту аннулирования.
// 
// Параметры:
//  ЭлементыСхемы - См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
//
Процедура ДобавитьЭлементыРегламентаАннулирования(ЭлементыСхемы)
	
	ИнформацияОтправителя = ЭлементыСхемы[Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя];
	Если ИнформацияОтправителя = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПОА = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ПОА, Истина);
	
	РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ПОА,
		Перечисления.ТипыЭлементовРегламентаЭДО.ПОА_УОУ, Истина);
	
КонецПроцедуры

// Добавляет элементы по регламенту отклонения.
// 
// Параметры:
//  ЭлементыСхемы - См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
//
Процедура ДобавитьЭлементыРегламентаОтклонения(ЭлементыСхемы, ЭтоВходящийЭДО)
	
	ИнформацияОтправителя = ЭлементыСхемы[Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя];
	Если ИнформацияОтправителя = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УОУ = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
		Перечисления.ТипыЭлементовРегламентаЭДО.УОУ, Истина);
	
	Если ЭтоВходящийЭДО Тогда
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, УОУ,
			Перечисления.ТипыЭлементовРегламентаЭДО.УОУ_ПДП);	
	Иначе
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, УОУ,
			Перечисления.ТипыЭлементовРегламентаЭДО.УОУ_ПДО);		
	КонецЕсли;
	
	РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, УОУ,
		Перечисления.ТипыЭлементовРегламентаЭДО.УОУ_ИОП);
	
КонецПроцедуры

#КонецОбласти

#Область СостояниеДокумента

// Возвращает признак успешности заполнения состояния по предложению об аннулировании.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоПредложениюОбАннулировании(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ПОА, ЭлементРегламента) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	
	ОтклонениеПОА = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	Если РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ПОА_УОУ, ОтклонениеПОА) Тогда
		
		Если ОтклонениеПОА.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
			
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеОтклонения;
			
		ИначеЕсли ОтклонениеПОА.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда
			
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеОтклонения;
			
		ИначеЕсли ОтклонениеПОА.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда
			
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаОтклонения;
			
		Иначе
			
			Результат = Ложь;
			
		КонецЕсли;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подтверждение Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодтверждениеАннулирования;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеАннулирования;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеАннулирования;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаАннулирования;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ОжидаетсяПодпись Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждениеАннулирования;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.Аннулирован;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по исходящему отклонению.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоИсходящемуОтклонению(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.УОУ, ЭлементРегламента) Тогда
		
		Результат = Ложь;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеОтклонения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеОтклонения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаОтклонения;
		
	ИначеЕсли Не ПараметрыДокумента.Исправлен Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяИсправление;
		
	ИначеЕсли Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.УОУ_ИОП, ЭлементРегламента) Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяИзвещениеПоОтклонению;
		
	Иначе
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ЗакрытСОтклонением;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по входящей информации отправителя.
// 
// Параметры:
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоВходящейИнформацииОтправителя(СостоянияЭлементовРегламента, Состояние)
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя, ЭлементРегламента) Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.НеПолучен;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Утверждение Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяУтверждение;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по исходящей информации получателя.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоИсходящейИнформацииПолучателя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Если Не ПараметрыДокумента.ТребуетсяПодтверждение Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя, ЭлементРегламента) Тогда
		
		Если ПараметрыДокумента.ОбменБезПодписи Тогда
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправке;
		Иначе
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписание;
		КонецЕсли;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписание;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправке;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправка;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по исходящему извещению о получении.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоИсходящемуИзвещениюОПолучении(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Если Не ПараметрыДокумента.ТребуетсяИзвещение Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИОП, ЭлементРегламента) Тогда
		
		Состояние =  Перечисления.СостоянияДокументовЭДО.ТребуетсяИзвещениеОПолучении;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеИзвещения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеИзвещения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаИзвещения;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по подтверждению оператора.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Подтверждение - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  Извещение - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоПодтверждениюОператора(ПараметрыДокумента, СостоянияЭлементовРегламента, Подтверждение, Извещение, Состояние)
	
	Результат = Ложь;
	
	Если Не РегламентыЭДО.ЭтоОбменЧерезОператора(ПараметрыДокумента.СпособОбмена) Тогда
		
		Возврат Результат;
		
	КонецЕсли;
	
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента, Подтверждение, ЭлементРегламента) Тогда
		
		РегламентыЭДО.УстановитьПриоритетноеСостояние(Состояние,
			 Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждениеОператора);
		
	ИначеЕсли Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента, Извещение, ЭлементРегламента) Тогда
		
		Результат = Истина;
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяИзвещениеОПолучении;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
		
		Результат = Истина;
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеИзвещения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Результат = Истина;
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеИзвещения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Результат = Истина;
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаИзвещения;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по исходящей информации отправителя.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоИсходящейИнформацииОтправителя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя, ЭлементРегламента) Тогда
		
		Состояние = РегламентыЭДО.НачальноеСостояниеДокумента();
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписание;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправке;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправка;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по входящему отклонению.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоВходящемуОтклонению(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.УОУ) Тогда
		
		Результат = Ложь;
		
	ИначеЕсли Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.УОУ_ИОП, ЭлементРегламента) Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяИзвещениеПоОтклонению;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеИзвещенияПоОтклонению;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеИзвещенияПоОтклонению;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаИзвещенияПоОтклонению;
		
	ИначеЕсли Не ПараметрыДокумента.Исправлен Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяУточнение;
		
	Иначе
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ЗакрытСОтклонением;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по входящему извещению о получении.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоВходящемуИзвещениюОПолучении(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Ложь;
	
	Если ПараметрыДокумента.ТребуетсяИзвещение
		И Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИОП) Тогда
		
		РегламентыЭДО.УстановитьПриоритетноеСостояние(Состояние, Перечисления.СостоянияДокументовЭДО.ОжидаетсяИзвещениеОПолучении);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по входящей информации получателя.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоВходящейИнформацииПолучателя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Ложь;
	
	Если ПараметрыДокумента.ТребуетсяПодтверждение
		И Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
			Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя) Тогда
		
		РегламентыЭДО.УстановитьПриоритетноеСостояние(Состояние, Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждение);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти