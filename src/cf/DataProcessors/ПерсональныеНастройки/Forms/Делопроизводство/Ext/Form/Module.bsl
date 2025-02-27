﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервереРедакцииКонфигурации();	
	
	ЧтениеВнутреннихДокументов = ПравоДоступа("Чтение", Метаданные.Справочники.ВнутренниеДокументы);
	ЧтениеВходящихДокументов = ПравоДоступа("Чтение", Метаданные.Справочники.ВходящиеДокументы);
	ЧтениеИсходящихДокументов = ПравоДоступа("Чтение", Метаданные.Справочники.ИсходящиеДокументы);
	
	Если НЕ ЧтениеВходящихДокументов Тогда
		Элементы.ГруппаВходящиеДокументы.Видимость = Ложь;
	КонецЕсли;
	
	Если НЕ ЧтениеИсходящихДокументов Тогда
		Элементы.ГруппаИсходящиеДокументы.Видимость = Ложь;
	КонецЕсли;
	
	Если НЕ ЧтениеВнутреннихДокументов Тогда
		Элементы.ГруппаВнутренниеДокументы.Видимость = Ложь;
	КонецЕсли;
	
	
	ИдентификаторКлиента = "";
	Если Параметры.Свойство("ИдентификаторКлиента") Тогда 
		ИдентификаторКлиента = Параметры.ИдентификаторКлиента;
	КонецЕсли;
	
	// Работа с документами
	ВидВнутреннегоДокумента =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСДокументами",
			"ВидВнутреннегоДокумента");
	
	ВидВходящегоДокумента =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСДокументами",
			"ВидВходящегоДокумента");
	
	ВидИсходящегоДокумента =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСДокументами",
			"ВидИсходящегоДокумента");
	
	СпособОтправки =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСДокументами",
			"СпособОтправки");
	
	СпособПолучения =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСДокументами",
			"СпособПолучения");
	
	ПоказыватьПредупреждениеПриРегистрации =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСДокументами",
			"ПоказыватьПредупреждениеПриРегистрации");
	
	Если ПоказыватьПредупреждениеПриРегистрации = Неопределено Тогда 
		ПоказыватьПредупреждениеПриРегистрации = Истина;
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиРаботыСДокументами",
			"ПоказыватьПредупреждениеПриРегистрации",
			ПоказыватьПредупреждениеПриРегистрации);
	КонецЕсли;
	
	
	НастройкаВариантПредупрежденияПриЗакрытииВходящего = 
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСДокументами",
			"ВариантПредупрежденияПриЗакрытииВходящего");
		
	Если НастройкаВариантПредупрежденияПриЗакрытииВходящего = Неопределено Тогда 
		// старая настройка
		ПоказыватьПредупреждениеПриЗакрытии = ХранилищеОбщихНастроек.Загрузить(
				"НастройкиРаботыСДокументами",
				"ПоказыватьПредупреждениеПриЗакрытии");
				
		Если ПоказыватьПредупреждениеПриЗакрытии = Неопределено Тогда 
			ПоказыватьПредупреждениеПриЗакрытии = Истина;
		КонецЕсли;	
		
		Если ПоказыватьПредупреждениеПриЗакрытии Тогда 
			ВариантПредупрежденияПриЗакрытииВходящего = "ПоказыватьПредупреждение";
		Иначе
			ВариантПредупрежденияПриЗакрытииВходящего = "ЗакрыватьБезРегистрации";
		КонецЕсли;	
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиРаботыСДокументами",
			"ВариантПредупрежденияПриЗакрытииВходящего",
			ВариантПредупрежденияПриЗакрытииВходящего);
	Иначе	
		ВариантПредупрежденияПриЗакрытииВходящего =
			НастройкаВариантПредупрежденияПриЗакрытииВходящего;
	КонецЕсли;		
		
	НастройкаИспользоватьОбзорДокументов =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСДокументами",
			"ИспользоватьОбзорДокументов");
	
	Если НастройкаИспользоватьОбзорДокументов = Неопределено Тогда 
		ИспользоватьОбзорДокументов = Истина;
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиРаботыСДокументами",
			"ИспользоватьОбзорДокументов",
			ИспользоватьОбзорДокументов);
	Иначе		
		ИспользоватьОбзорДокументов = НастройкаИспользоватьОбзорДокументов;	
	КонецЕсли;
	
	Организация = 
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСДокументами",
			"Организация");
	
	Валюта =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСДокументами",
			"Валюта");
	
	СпособОтраженияПередачиКонтрагенту =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСДокументами",
			"СпособОтраженияПередачиКонтрагенту");
	
	Если СпособОтраженияПередачиКонтрагенту = Неопределено Тогда
		СпособОтраженияПередачиКонтрагенту = Перечисления.СпособыОтраженияПередачиКонтрагенту.ЗадаватьВопрос;
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиРаботыСДокументами",
			"СпособОтраженияПередачиКонтрагенту",
			СпособОтраженияПередачиКонтрагенту);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбработатьЗакрытие", 
		ЭтотОбъект);

	ПоказатьВопрос(ОписаниеОповещения,
		НСтр("ru = 'Данные были изменены. Сохранить изменения?'"),
		РежимДиалогаВопрос.ДаНетОтмена,,
		КодВозвратаДиалога.Да);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	Если НеобходимостьОбновленияИнтерфейса Тогда
		ОбновитьПовторноИспользуемыеЗначения();
		ОбновитьИнтерфейсКлиент();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьНастройки();
	НеобходимостьОбновленияИнтерфейса = Истина;
	Модифицированность = Ложь;
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьЗакрытие(Ответ, Параметры) Экспорт 

	Если Ответ = КодВозвратаДиалога.Да Тогда
		СохранитьНастройки();
		НеобходимостьОбновленияИнтерфейса = Истина;
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть();

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	МассивСтруктур = Новый Массив;
	
	// НастройкиРаботыСДокументами
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСДокументами", 
		"ВидВнутреннегоДокумента", ВидВнутреннегоДокумента);
	ДобавитьСтруктуруНастройки(МассивСтруктур, 
		"НастройкиРаботыСДокументами", "ВидВходящегоДокумента", ВидВходящегоДокумента);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСДокументами", 
		"ВидИсходящегоДокумента", ВидИсходящегоДокумента);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСДокументами", 
		"СпособОтправки", СпособОтправки);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСДокументами", 
		"СпособПолучения", СпособПолучения);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСДокументами", 
		"ПоказыватьПредупреждениеПриРегистрации", ПоказыватьПредупреждениеПриРегистрации);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСДокументами", 
		"ВариантПредупрежденияПриЗакрытииВходящего", ВариантПредупрежденияПриЗакрытииВходящего);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСДокументами", 
		"Организация", Организация);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСДокументами", 
		"Валюта", Валюта);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСДокументами", 
		"СпособОтраженияПередачиКонтрагенту", СпособОтраженияПередачиКонтрагенту);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСДокументами", 
		"ИспользоватьОбзорДокументов", ИспользоватьОбзорДокументов);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтруктуруНастройки(МассивСтруктур, Объект, Настройка = Неопределено, Значение)
	
	МассивСтруктур.Добавить(Новый Структура ("Объект, Настройка, Значение", Объект, Настройка, Значение));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсКлиент()
	
	УстанавливаемыеПараметры = Новый Структура;
	УстанавливаемыеПараметры.Вставить("Пользователи", ПользователиКлиентСервер.ТекущийПользователь());
	УстановитьПараметрыФункциональныхОпцийИнтерфейса(УстанавливаемыеПараметры);
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервереРедакцииКонфигурации()	
	
	Элементы.Организация.Заголовок = РедакцииКонфигурацииКлиентСервер.Организация();
		
КонецПроцедуры

#КонецОбласти
