﻿
#Область ОписаниеПеременных

&НаСервере
Перем КонтрагентПодключенКСервису1СЭДО;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не НастройкиЭДО.ЕстьПравоНастройкиОбмена() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Организация             = Параметры.Организация;
	Контрагент              = Параметры.Контрагент;
	ДополнительныеПараметры = Параметры.ДополнительныеПараметры;
	
	HTMLДокумент = Обработки.ОбменСКонтрагентами.ПолучитьМакет(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"ПредложениеОформитьЗаявлениеНаПодключение_%1", ОбщегоНазначения.КодОсновногоЯзыка())).ПолучитьТекст();
	Если ЗначениеЗаполнено(Контрагент) Тогда
		
		HTMLДокумент = Обработки.ОбменСКонтрагентами.ПолучитьМакет(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"ПредложениеОформитьЗаявлениеНаПодключениеИзСправочникаКонтрагенты_%1",
			ОбщегоНазначения.КодОсновногоЯзыка())).ПолучитьТекст();
	КонецЕсли;
	
	ПодготовитьФорму(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// В случае полного набора параметров сразу стартуем помощник подключения в 1С-ЭДО.
	Если ЗначениеЗаполнено(ДополнительныеПараметры) Тогда
		
		НачатьОткрытиеПомощникаПодключенияЭДО();
		Возврат;
		
	ИначеЕсли НастройкиОтправкиСозданы Тогда
		Отказ = Истина;
		
		ПараметрыОткрытияПомощникаОтправки = ПриглашенияЭДОКлиент.НовыеПараметрыОткрытияПомощникаОтправкиПриглашения();
		ПараметрыОткрытияПомощникаОтправки.Контрагент = Контрагент;
		ПараметрыОткрытияПомощникаОтправки.Организация = Организация;
		ПараметрыОткрытияПомощникаОтправки.РежимОткрытия = РежимОткрытияОкнаФормы.Независимый;
		СинхронизацияЭДОКлиент.ОткрытьПомощникОтправкиПриглашения(ПараметрыОткрытияПомощникаОтправки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияЗаголовокНажатие(Элемент)
	
	АдресСтраницы = "https://portal.1c.ru/applications/30";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НажатиеПоказатьПозже(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключиться(Команда)
	
	Если ПодключитьсяКЭДО() Тогда
		
		ЗакрытьФорму = Истина;
		Если УчетнаяЗаписьСоздана И ЗначениеЗаполнено(Контрагент) Тогда
			КлючНастроек = НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки();
			КлючНастроек.Отправитель = Организация;
			КлючНастроек.Получатель = Контрагент;
			НастройкиЭДОКлиент.НастроитьОбменСКонтрагентом(КлючНастроек);
		Иначе
			
			Если ТипПодключенияЭДО = 1 Тогда
				ЗакрытьФорму = Ложь;
				НачатьОткрытиеПомощникаПодключенияЭДО();
			Иначе
				ПараметрыФормы = Новый Структура("Ссылка", Организация);
				ФормаПомощникаБизнесСети = "Обработка.БизнесСеть.Форма.ПодключениеУчастников";
				ОткрытьФорму(ФормаПомощникаБизнесСети, ПараметрыФормы, ЭтотОбъект.ВладелецФормы);
			КонецЕсли;
			
		КонецЕсли;
		Если ЗакрытьФорму Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПодключитьсяКЭДО()
	
	Если СинхронизацияЭДО.ЕстьПравоВыполненияОбмена(Истина) Тогда
		УстановитьЗначенияКонстант();
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьЗначенияКонстант()
	
	НастройкиЭДО.УстановитьИспользованиеЭДО(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФорму(Отказ)
	
	ТипПодключенияЭДО    = 1;
	УчетнаяЗаписьСоздана = Ложь;
	
	КлючСохраненияПоложенияОкна = УникальныйИдентификатор;
	
	Отбор = УчетныеЗаписиЭДО.НовыйОтборУчетныхЗаписей();
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Организация = "&Организация";
	КонецЕсли;
	ЗапросУчетныхЗаписей = УчетныеЗаписиЭДО.ЗапросУчетныхЗаписей("УчетныеЗаписиЭДО", Отбор);
	
	Запросы = Новый Массив;
	Запросы.Добавить(ЗапросУчетныхЗаписей);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО,
	|	УчетныеЗаписиЭДО.Организация КАК Организация
	|ИЗ
	|	УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО";
	
	ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
	Если ЗначениеЗаполнено(Организация) Тогда
		ИтоговыйЗапрос.УстановитьПараметр("Организация", Параметры.Организация);
	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = ИтоговыйЗапрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			
			Если Не ЗначениеЗаполнено(Организация) Тогда
				Организация = Выборка.Организация;
			КонецЕсли;
			
			УчетнаяЗаписьСоздана = Истина;
		КонецЕсли;
	КонецЕсли;
	
	НастройкиОтправкиСозданы = НастройкиЭДО.ЕстьНастройкиОтправки(Параметры.Организация, Параметры.Контрагент);
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		КонтрагентПодключенКСервису1СЭДО = ИнтеграцияЭДО.КонтрагентПодключенКСервису1СЭДО(Контрагент);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) И УчетнаяЗаписьСоздана И Не ЗначениеЗаполнено(Контрагент) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если УчетнаяЗаписьСоздана И ЗначениеЗаполнено(Контрагент) Тогда
		
		УстановитьЗначенияКонстант();
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры) Тогда
		УстановитьЗначенияКонстант();
	КонецЕсли;
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.ДекорацияПроверка.Заголовок = НСтр("ru = 'Из этой программы можно обмениваться электронными документами с контрагентами.'");
	
	Если КонтрагентПодключенКСервису1СЭДО Тогда
		ШаблонТекстаДекорации = НСтр("ru = 'С контрагентом ""%1"" можно обмениваться электронными документами
		|из этой программы.'");
		Элементы.ДекорацияПроверка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаДекорации,
		Контрагент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОткрытиеПомощникаПодключенияЭДО()
	
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьПомощникПодключенияЭДО", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПомощникПодключенияЭДО()
	
	ОписаниеОповещенияОЗакрытии = Неопределено;
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
	
	ПараметрыСоздания = УчетныеЗаписиЭДОКлиент.НовыеПараметрыСозданияУчетнойЗаписи();
	ПараметрыСоздания.Организация = Организация;
	ПараметрыСоздания.Контрагент = Контрагент;
	ПараметрыСоздания.СпособыОбмена.Добавить(
		ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезСервис1СЭДО"));
	ПараметрыСоздания.ДополнительныеПараметры = ДополнительныеПараметры;
	УчетныеЗаписиЭДОКлиент.СоздатьУчетнуюЗапись(ПараметрыСоздания);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

КонтрагентПодключенКСервису1СЭДО = Ложь;

#КонецОбласти

