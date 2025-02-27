﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РегламентированнаяОтчетностьПереопределяемый.ПолучитьСписокОтчетовИУведомленийВходяшихВРасширенныйФункционал(ОтчетыВходяшиеВРасширенныйФункционал);
	
	Данные = Неопределено;
	Параметры.Свойство("Данные", Данные);
	АдресДанные = ПоместитьВоВременноеХранилище(Данные, УникальныйИдентификатор);
	
	СозданиеСообщения = Параметры.Свойство("Создание_УведомлениеОСпецрежимахНалогообложения");
	УчитыватьУведомленияНеВходящиеВБРО = Параметры.Свойство("УчитыватьУведомленияНеВходящиеВБРО");
	Параметры.Свойство("UIDФорма1СОтчетность", UIDФорма1СОтчетность);
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;
	
	Если Параметры.Свойство("ВидУведомления") Тогда
		ВидУведомления = Параметры.ВидУведомления;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		Организация = ОргПоУмолчанию;
	ИначеЕсли Не ЗначениеЗаполнено(Организация) Тогда 
		Попытка
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
			|	Организации.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Организации КАК Организации
			|ГДЕ
			|	НЕ Организации.ПометкаУдаления";
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
				Организация = Выборка.Ссылка;
			КонецЕсли;
		Исключение
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Не удалось определить организацию по умолчанию'"));
		КонецПопытки;
	КонецЕсли;
	
	ЭтоЗаявлениеПФР = ВидУведомления = Новый ОписаниеТипов("ДокументСсылка.ЗаявленияПоЭлДокументооборотуСПФР");
	Если СозданиеСообщения И ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ВидУведомления) И НЕ ЭтоЗаявлениеПФР Тогда
		Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
			Если Не ДанноеСообщениеДоступноДляОрганизации(ВидУведомления) Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Уведомление %1 не доступно для организации'"), ВидУведомления);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		Иначе
			Если Не ДанноеСообщениеДоступноДляИП(ВидУведомления) Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Уведомление %1 не доступно для индивидуального предпринимателя'"), ВидУведомления);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Формируем список уведомлений
	Если Параметры.Свойство("ВидыПрочихУведомлений")
		И ТипЗнч(Параметры.ВидыПрочихУведомлений) = Тип("Массив") Тогда 
		
		ВидыУведомленийОрг = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВидыУведомленийДляОрганизации();
		ВидыУведомленийИП = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВидыУведомленийДляИП();
		
		Для Каждого Элемент Из Параметры.ВидыПрочихУведомлений Цикл
			Если ВидыУведомленийИП.Найти(Элемент) <> Неопределено Тогда 
				ВидыСообщенийИП.Добавить(Элемент);
			КонецЕсли;
			Если ВидыУведомленийОрг.Найти(Элемент) <> Неопределено Тогда 
				ВидыСообщенийОрганизации.Добавить(Элемент);
			КонецЕсли;
			ВидыСообщенийОбщий.Добавить(Элемент);
		КонецЦикла;
		СформироватьСписок();
	Иначе 
		СформироватьДерево();
	КонецЕсли;
	
	ОрганизацияПредидущийВыбор = Организация;
	Если ЗначениеЗаполнено(Организация) Тогда 
		Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
			ЗначениеВРеквизитФормы(РеквизитФормыВЗначение("ДеревоУведомленийООО"), "ВидыСообщений");
		Иначе
			ЗначениеВРеквизитФормы(РеквизитФормыВЗначение("ДеревоУведомленийИП"), "ВидыСообщений");
		КонецЕсли;
	КонецЕсли;
	
	// Если вид уведомления известен, то позиционируемся на нем
	Если ЗначениеЗаполнено(ВидУведомления) Тогда
		ВидУведомления = Параметры.ВидУведомления;
		Идентификатор = Неопределено;
		ПолучитьИдентификаторНужногоЭлемента(ВидыСообщений.ПолучитьЭлементы(), ВидУведомления, Идентификатор);
		Элементы.ВидыСообщений.ТекущаяСтрока = Идентификатор;
	КонецЕсли;
	
	Если СозданиеСообщения Тогда
		Элементы.Выбрать.Доступность = ЗначениеЗаполнено(Организация);
	Иначе
		Элементы.Организация.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Если организация и ВидУведомления заполнены, то пропускаем эту форму, сразу создаем объект (только в режиме создания)
	Если СозданиеСообщения Тогда
		Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ВидУведомления) Тогда
			Данные = Элементы.ВидыСообщений.ТекущиеДанные;
			Если Данные <> Неопределено Тогда
				ОбработкаВыбораВидаУведомления(Данные.Тип, Данные.Наименование);
			КонецЕсли;
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидыСообщенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Организация) И СозданиеСообщения Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Укажите организацию'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),, "Организация");
		Возврат;
	КонецЕсли;
	
	Данные = Элементы.ВидыСообщений.ТекущиеДанные;
	Если Данные <> Неопределено Тогда
		ОбработкаВыбораВидаУведомления(Данные.Тип, Данные.Наименование);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	НаложитьОтборы();
КонецПроцедуры

&НаКлиенте
Процедура ПоискОчистка(Элемент, СтандартнаяОбработка)
	НаложитьОтборы();
КонецПроцедуры

&НаКлиенте
Процедура ПоискПриИзменении(Элемент)
	НаложитьОтборы();
КонецПроцедуры

&НаКлиенте
Процедура ПоискИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Элемент.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.НеИспользовать;
	Поиск = Текст;
	НаложитьОтборы();
	ЭтаФорма.ТекущийЭлемент = Элемент;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Данные = Элементы.ВидыСообщений.ТекущиеДанные;
	Если Данные <> Неопределено Тогда
		ОбработкаВыбораВидаУведомления(Данные.Тип, Данные.Наименование);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПерестроитьДерево(ВидУведомленияВыбранный)
	ТермыПоиска = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Поиск, " ", Истина, Истина);
	Хеш = ПолучитьХеш(Поиск);
	Если Организация <> ОрганизацияПредидущийВыбор Или ПрошлыйХеш <> Хеш Тогда
		ЗначениеВРеквизитФормы(РеквизитФормыВЗначение("ДеревоУведомленийОбщее"), "ВидыСообщений");
		ФильтроватьСтроки(ВидыСообщений.ПолучитьЭлементы(), Организация, Хеш, РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация), ТермыПоиска);
	КонецЕсли;
	ОрганизацияПредидущийВыбор = Организация;
	ПрошлыйХеш = Хеш;
КонецПроцедуры

&НаСервере
Процедура СформироватьСписок()
	
	КорневойУровень = ВидыСообщений.ПолучитьЭлементы();
	КорневойУровень.Очистить();
	ДеревоУведомлений = РеквизитФормыВЗначение("ВидыСообщений");
	
	ДеревоУведомленийООО.ПолучитьЭлементы().Очистить();
	ДеревоУведомленийИП.ПолучитьЭлементы().Очистить();
	
	Если Не ЗначениеЗаполнено(Организация) Тогда 
		Список = ВидыСообщенийОбщий;
	ИначеЕсли РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
		Список = ВидыСообщенийОрганизации;
	Иначе 
		Список = ВидыСообщенийИП;
	КонецЕсли;
	
	Для Каждого ОтправляемыйЭлемент Из Список Цикл
		ДобавитьВеткуВДеревоУведомлений(ДеревоУведомлений.Строки, ОтправляемыйЭлемент.Значение);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоУведомлений, "ВидыСообщений");
	ЗначениеВРеквизитФормы(ДеревоУведомлений, "ДеревоУведомленийОбщее");
	СформироватьДеревоОООИП(ДеревоУведомленийООО, ВидыСообщений, Ложь);
	СформироватьДеревоОООИП(ДеревоУведомленийИП, ВидыСообщений, Истина);
	
	ПерестроитьДерево(Неопределено);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДанноеСообщениеДоступноДляИП(Вид)
	Возврат (УведомлениеОСпецрежимахНалогообложенияВызовСервера.ВидыУведомленийДляИП().Найти(Вид) <> Неопределено);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДанноеСообщениеДоступноДляОрганизации(Вид)
	Возврат (УведомлениеОСпецрежимахНалогообложенияВызовСервера.ВидыУведомленийДляОрганизации().Найти(Вид) <> Неопределено);
КонецФункции

&НаСервере
Процедура ДобавитьВеткуУСН(КорневойУровень, ФлагиУчета)
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.СервисЭлектронныхТрудовыхКнижек Тогда
		Возврат;
	КонецЕсли;
	
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "УСН";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбИзмененииОбъектаНалогообложенияПоУСН);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбОтказеОтУСН);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбУтратеПраваНаУСН);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеПереходНПДУСН);
	
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда //Доступна и активна упрощенная отчетность
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПереходеНаУСН);
	КонецЕсли;

	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПрекращенииДеятельностиПоУСН);
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьВеткуТорговыйСбор(КорневойУровень, ФлагиУчета)
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.СервисЭлектронныхТрудовыхКнижек Тогда
		Возврат;
	КонецЕсли;
	
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "Торговый сбор";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС2);
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьВеткуПатентнаяСистема(КорневойУровень, ФлагиУчета)
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.СервисЭлектронныхТрудовыхКнижек Тогда
		Возврат;
	КонецЕсли;
	
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "Патентная система";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатентаРекомендованнаяФорма);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОбУтратеПраваНаПатент);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеУменьшениеНалогаККТ);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УменьшениеНалогаНаСтраховыеВзносы);
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьВеткуНДС(КорневойУровень, ФлагиУчета)
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.СервисЭлектронныхТрудовыхКнижек Тогда
		Возврат;
	КонецЕсли;
	
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "НДС";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ОсвобождениеОтУплатыНДС);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ОсвобождениеОтНДСПриЕСХН);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.РеестрДокументовПодтверждающихЛьготы);
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьВеткуЕСХН(КорневойУровень, ФлагиУчета)
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.СервисЭлектронныхТрудовыхКнижек Тогда
		Возврат;
	КонецЕсли;
	
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "ЕСХН";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПереходНаЕСХН);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеПрекращениеЕСХН);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеПереходНПДЕСХН);
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьВеткуНДД(КорневойУровень, ФлагиУчета)
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.СервисЭлектронныхТрудовыхКнижек Тогда
		Возврат;
	КонецЕсли;
	
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "Налог на дополнительный доход";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеНДДДУС);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНДДДУС);
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьВеткуУчастиеВИностранныхОрганизациях(КорневойУровень, ФлагиУчета)
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.СервисЭлектронныхТрудовыхКнижек Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		// Ветка иностранные организации
		Папка = КорневойУровень.Добавить();
		Папка.Наименование = "Участие в иностранных организациях";
		Папка.ИндексКартинки = 0;
		ЭлементыПапки = Папка.Строки;
		
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаУ_ИО);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаКИК);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаСИО);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеКЛМК);
		Если ЭлементыПапки.Количество() = 0 Тогда 
			КорневойУровень.Удалить(Папка);
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьВеткуОбособленныеПодразделения(КорневойУровень, ФлагиУчета)
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.СервисЭлектронныхТрудовыхКнижек Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		Папка = КорневойУровень.Добавить();
		Папка.Наименование = "Обособленные подразделения";
		Папка.ИндексКартинки = 0;
		ЭлементыПапки = Папка.Строки;
		
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Форма_1_6_Учет);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_1);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_2);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СообщениеОНаделенииОППолномочиямиПоВыплатам);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеПорядокУплатыПрибыль);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВыборНалоговогоОрганаНДФЛ);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Уведомление1НачалоУплаты);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Уведомление2ОтказОтУплаты);
		Если ЭлементыПапки.Количество() = 0 Тогда 
			КорневойУровень.Удалить(Папка);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьВеткуВзаиморасчетыСНалоговой(КорневойУровень, ФлагиУчета)
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.СервисЭлектронныхТрудовыхКнижек Тогда
		Возврат;
	КонецЕсли;
	
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "Взаиморасчеты с налоговой инспекцией";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеЛьготаТранспортЗемля);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СообщениеТранспортЗемля);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОВозвратеНалога);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОЗачетеНалога);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеПорядокПредставленияНалоговыхДеклараций);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОГибелиТранспортногоСредства);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПредоставленииРассрочкиПоНалоговымПлатежам);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ИзменениеПорядкаИсчисленияАвансовПоНалогуНаПрибыль);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СверкаРасчетовПоНалогам);
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьВеткуПрочее(КорневойУровень, ФлагиУчета)
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.СервисЭлектронныхТрудовыхКнижек Тогда
		Возврат;
	КонецЕсли;
	
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "Прочее";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	ПапкаСчета = ЭлементыПапки.Добавить();
	ПапкаСчета.Наименование = "Счета в иностранных банках";
	ПапкаСчета.ИндексКартинки = 0;
	ЭлементыПапкиСчета = ПапкаСчета.Строки;
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапкиСчета, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбОткрытииЗакрытииСчета);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапкиСчета, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбИзмененииРеквизитовСчета);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапкиСчета, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОНаличииСчета);
	Если ЭлементыПапкиСчета.Количество() = 0 Тогда 
		ЭлементыПапки.Удалить(ПапкаСчета);
	КонецЕсли;
	
	ДобавитьВеткуНалоговыйМониторинг(ЭлементыПапки, ФлагиУчета);
	
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ДекларацияОХарактеристикахОбъектаНедвижимости);
	КонецЕсли;
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаСубсидиюДляЗарплаты);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СубсидияНаПроведениеПрофилактики);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗапросСведенийСоставляющихНалоговуюТайну);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ИзменениеРегиональныхНалогов);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПриемДокументовФСС);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеИсключенииПроверки);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеПостановкаОбъектаНВОС);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.НевозможностьПредоставленияДокументов);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеРанееПредставленныеДокументы);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОсвобождениеОтСтраховыхВзносов);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР13001);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР13014);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР14001);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР24001);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВозвратСуммыНВОС);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗачетСуммыНВОС);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СогласиеНаИнформированиеОЗадолженности);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЖалобаФНС);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВыдачаСправкиПоРасчетам);
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПредоставленииРассрочкиФСС);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПостановкаСнятиеВКачествеНалоговогоАгента);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПримененииНалоговойЛьготыУчастникамиРегиональныхИнвестиционныхПроектов);
	КонецЕсли;
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_6);
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СогласиеНаРаскрытиеНалоговойТайны);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеУчастникаСколково);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОсвобождениеНалогНаПрибыльСколково);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОсвобождениеНДССколково);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеДокументаНалоговогоРезидента);
	КонецЕсли;	
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьВеткуНалоговыйМониторинг(КорневойУровень, ФлагиУчета)
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.СервисЭлектронныхТрудовыхКнижек Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		Папка = КорневойУровень.Добавить();
		Папка.Наименование = "Налоговый мониторинг";
		Папка.ИндексКартинки = 0;
		ЭлементыПапки = Папка.Строки;
		
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, 
			Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПроведенииНалоговогоМониторинга);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, 
			Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ИнформацияОбОрганизацииСистемыВнутреннегоКонтроля);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, 
			Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ИнформацияОбУчастниках);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, 
			Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УчетнаяПолитика);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, 
			Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.РегламентИнформационногоВзаимодействия);
		Если ЭлементыПапки.Количество() = 0 Тогда 
			КорневойУровень.Удалить(Папка);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьДерево()
	
	ФлагиУчета = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПолучитьФлагиИнтеграцииПоУмолчанию();
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиПереопределяемый.ПолучитьЗначенияКонстантИнтеграции(ФлагиУчета);
	ДеревоУведомлений = РеквизитФормыВЗначение("ВидыСообщений");
	
	КорневойУровень = ДеревоУведомлений.Строки;
	ДобавитьВеткуУСН(КорневойУровень, ФлагиУчета);
	ДобавитьВеткуТорговыйСбор(КорневойУровень, ФлагиУчета);
	ДобавитьВеткуПатентнаяСистема(КорневойУровень, ФлагиУчета);
	ДобавитьВеткуНДС(КорневойУровень, ФлагиУчета);
	ДобавитьВеткуЕСХН(КорневойУровень, ФлагиУчета);
	ДобавитьВеткуНДД(КорневойУровень, ФлагиУчета);
	ДобавитьВеткуУчастиеВИностранныхОрганизациях(КорневойУровень, ФлагиУчета);
	ДобавитьВеткуОбособленныеПодразделения(КорневойУровень, ФлагиУчета);
	ДобавитьВеткуВзаиморасчетыСНалоговой(КорневойУровень, ФлагиУчета);
	
	ТаблицаОписанияЗаявлений = РегламентированнаяОтчетность.ПустаяТаблицаОписанияОбъектовРегламентированнойОтчетности();
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОпределитьТаблицуОписанияОбъектовЗаявленияПоЭлДокументооборотуСПФР(ТаблицаОписанияЗаявлений);
	ДобавитьКДеревуПрочиеУведомление(ДеревоУведомлений, ТаблицаОписанияЗаявлений);
	
	ДобавитьВеткуПрочее(КорневойУровень, ФлагиУчета);
	
	// Уведомления, не входящие в БРО
	Если УчитыватьУведомленияНеВходящиеВБРО Тогда
		ТаблицаОписанияОбъектов = РегламентированнаяОтчетность.ТаблицаОписанияОбъектовРегламентированнойОтчетности();
		ДобавитьКДеревуПрочиеУведомление(ДеревоУведомлений, ТаблицаОписанияОбъектов);
	КонецЕсли;
	
	Для Каждого Стр Из ДеревоУведомлений.Строки Цикл 
		Стр.Строки.Сортировать("ИндексКартинки, Наименование", Истина);
	КонецЦикла;
	СоответствиеАдрес = ПоместитьВоВременноеХранилище(ЭтотОбъект.УникальныйИдентификатор);
	
	ЗначениеВРеквизитФормы(ДеревоУведомлений, "ВидыСообщений");
	ЗначениеВРеквизитФормы(ДеревоУведомлений, "ДеревоУведомленийОбщее");
	СформироватьДеревоОООИП(ДеревоУведомленийООО, ВидыСообщений, Ложь);
	СформироватьДеревоОООИП(ДеревоУведомленийИП, ВидыСообщений, Истина);
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоОООИП(НовЭлтРек, ИсхЭлт, ДляИП)
	Для Каждого Элт Из ИсхЭлт.ПолучитьЭлементы() Цикл 
		ЭтоПапка = (Элт.ПолучитьЭлементы().Количество() > 0);
		Если ЭтоПапка Тогда
			НовЭлтПапка = НовЭлтРек.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(НовЭлтПапка, Элт);
			СформироватьДеревоОООИП(НовЭлтПапка, Элт, ДляИП);
		Иначе
			Если ТипЗнч(Элт.Тип) <> Тип("ПеречислениеСсылка.ВидыУведомленийОСпецрежимахНалогообложения")
				Или (ДляИП И ДанноеСообщениеДоступноДляИП(Элт.Тип))
				Или ((Не ДляИП) И ДанноеСообщениеДоступноДляОрганизации(Элт.Тип)) Тогда 
				
				НовЭлт = НовЭлтРек.ПолучитьЭлементы().Добавить();
				ЗаполнитьЗначенияСвойств(НовЭлт, Элт);
			КонецЕсли;
		КонецЕсли;
		
		Если ЭтоПапка И (НовЭлтПапка.ПолучитьЭлементы().Количество() = 0) Тогда
			НовЭлтРек.ПолучитьЭлементы().Удалить(НовЭлтПапка);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДобавитьКДеревуПрочиеУведомление(ДеревоУведомлений, ТаблицаОписанияОбъектов)

	ТаблицаОписанияУведомлений = ТаблицаОписанияОбъектов.Скопировать(Новый Структура("ВидДокумента, ЯвляетсяАктуальным", Перечисления.СтраницыЖурналаОтчетность.Уведомления, Истина));
	
	// Получаем имена всех групп
	Группы = Новый Массив;
	Для каждого СтрокаТаблицыОписанияУведомлений Из ТаблицаОписанияУведомлений Цикл
		Если Группы.Найти(СтрокаТаблицыОписанияУведомлений.ГруппаВДереве) = Неопределено Тогда
			Группы.Добавить(СтрокаТаблицыОписанияУведомлений.ГруппаВДереве);
		КонецЕсли;
	КонецЦикла;
	
	КорневойУровень = ДеревоУведомлений.Строки;
	
	// Строим дерево
	Для каждого Группа Из Группы Цикл
		
		СтрокиОбъектовДаннойГруппы = ТаблицаОписанияУведомлений.НайтиСтроки(Новый Структура("ГруппаВДереве", Группа));
		Если Группа = "" Тогда
			
			// Если нет группы, добавляем в корень
			Для каждого СтрокаОбъектовДаннойГруппы Из СтрокиОбъектовДаннойГруппы Цикл
			
				Сообщение = КорневойУровень.Добавить();
				Сообщение.Наименование = СтрокаОбъектовДаннойГруппы.Наименование;
				Сообщение.Хеш = ПолучитьХеш(Сообщение.Наименование);
				МассивТипов = Новый Массив;
				МассивТипов.Добавить(СтрокаОбъектовДаннойГруппы.ТипОбъекта);
				Сообщение.Тип = Новый ОписаниеТипов(МассивТипов);
				Сообщение.ИндексКартинки = 1;
				
				Сообщение.КонтролирующийОрган = СтрокаОбъектовДаннойГруппы.ВидКонтролирующегоОргана;
			
			КонецЦикла; 
		
		Иначе
			
			// Создаем папку
			Папка = ДеревоУведомлений.Строки.Добавить();
			Папка.Наименование = Группа;
			Папка.ИндексКартинки = 0;
			ЭлементыПапки = Папка.Строки;
			
			// Добавляем в папку элементы
			Для каждого СтрокаОбъектовДаннойГруппы Из СтрокиОбъектовДаннойГруппы Цикл
				Сообщение = ЭлементыПапки.Добавить();
				
				Сообщение.Наименование 	= СтрокаОбъектовДаннойГруппы.Наименование;
				Сообщение.Хеш = ПолучитьХеш(Сообщение.Наименование);
				МассивТипов = Новый Массив;
				МассивТипов.Добавить(СтрокаОбъектовДаннойГруппы.ТипОбъекта);
				Сообщение.Тип = Новый ОписаниеТипов(МассивТипов);
				Сообщение.ИндексКартинки = 1;
				
				Сообщение.КонтролирующийОрган = СтрокаОбъектовДаннойГруппы.ВидКонтролирующегоОргана;
			КонецЦикла;
			
		КонецЕсли;
	
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Функция ЭтоЮридическоеЛицо(Организация)
	
	Возврат РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация);
	
КонецФункции

&НаСервере
Функция ЭтотТипНеВходитВБРО(Тип) Экспорт
	
	ТаблицаОбъектовНеВходящихВБРО = РегламентированнаяОтчетность.ТаблицаОписанияОбъектовРегламентированнойОтчетности();
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОпределитьТаблицуОписанияОбъектовЗаявленияПоЭлДокументооборотуСПФР(ТаблицаОбъектовНеВходящихВБРО);
	СведенияПоОбъекту = ТаблицаОбъектовНеВходящихВБРО.Найти(Тип, "ТипОбъекта");
	
	Возврат СведенияПоОбъекту <> Неопределено;
	
КонецФункции

&НаСервере
Функция ПолноеИмяОбъектаМетаданных(Тип)
	
	Возврат Метаданные.НайтиПоТипу(Тип).ПолноеИмя();
	
КонецФункции

&НаСервере
Процедура ДобавитьВеткуВДеревоУведомлений(Родитель, ТипУведомления)
	Если ОтчетыВходяшиеВРасширенныйФункционал.НайтиПоЗначению(ТипУведомления) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОтчета = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПолучитьИмяОтчетаПоВидуУведомления(ТипУведомления);
	Если (ЗначениеЗаполнено(ИмяОтчета) И Метаданные.Отчеты.Найти(ИмяОтчета) = Неопределено)
		Или Не ЗначениеЗаполнено(ИмяОтчета) 
		Или Метаданные.Отчеты.Найти(ИмяОтчета) = Неопределено Тогда 
		
		Возврат;
	КонецЕсли;
	
	Сообщение = Родитель.Добавить();
	Сообщение.Наименование = Строка(ТипУведомления);
	Сообщение.ИндексКартинки = 1;
	Сообщение.Хеш = ПолучитьХеш(Сообщение.Наименование);
	Если ТипЗнч(ТипУведомления) = Тип("ПеречислениеСсылка.ВидыУведомленийОСпецрежимахНалогообложения") Тогда 
		Сообщение.Тип = ТипУведомления;
		Сообщение.Хеш = Сообщение.Хеш + Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПолучитьХеш(ТипУведомления);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораВидаУведомления(Тип, Наименование)
	
	Данные = ПолучитьИзВременногоХранилища(АдресДанные);
	
	Если ТипЗнч(Тип) = Тип("ПеречислениеСсылка.ВидыУведомленийОСпецрежимахНалогообложения") Тогда
		
		ВидУведомления = Тип;
		
		Если СозданиеСообщения Тогда
			
			ЭтоЮридическоеЛицо = ЭтоЮридическоеЛицо(Организация);
			
			Если ЭтоЮридическоеЛицо Тогда
				
				// Проверка на организаций
				Если НЕ ДанноеСообщениеДоступноДляОрганизации(ВидУведомления) Тогда
					
					ТекстПредупреждения = НСтр("ru = 'Уведомление ""%1"" можно создавать только для ИП'");
					ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", Строка(ВидУведомления));
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = ТекстПредупреждения;
					Сообщение.Сообщить();
					
					Возврат;
				КонецЕсли;
				
			Иначе
				
				// Проверка на ИП
				Если НЕ ДанноеСообщениеДоступноДляИП(ВидУведомления) Тогда
					
					ТекстПредупреждения = НСтр("ru = 'Уведомление ""%1"" можно создавать только для организаций'");
					ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", Строка(ВидУведомления));
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = ТекстПредупреждения;
					Сообщение.Сообщить();
					
					Возврат;
				КонецЕсли;
				
			КонецЕсли;
			
			СтандартнаяОбработка = Истина;
			Попытка
				РегламентированнаяОтчетностьКлиентПереопределяемый.ПередОткрытиемФормыУведомления(Организация, ВидУведомления, СтандартнаяОбработка);
			Исключение
				СтандартнаяОбработка = Истина;
			КонецПопытки;
			
			ПараметрыУведомления = Новый Структура;
			ПараметрыУведомления.Вставить("Организация", Организация);
			ПараметрыУведомления.Вставить("ВидУведомления", ВидУведомления);
			ПараметрыУведомления.Вставить("UIDФорма1СОтчетность", UIDФорма1СОтчетность);
			ПараметрыУведомления.Вставить("Данные", Данные);
			
			Если СтандартнаяОбработка Или Данные <> Неопределено Тогда
				ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.ФормаОбъекта",  ПараметрыУведомления, ЭтотОбъект.ВладелецФормы);
			Иначе
				Оповестить("РеализованаНестандартнаяОбработкаОткрытияУведомления", ПараметрыУведомления);
			КонецЕсли;
			
		КонецЕсли;
		
		Закрыть(ВидУведомления);
			
	Иначе
		
		// Если это тип, не входящий в БРО, то объект создаем с помощью переопределемого метода
		ТипСоздаваемогоОбъекта = ?(ТипЗнч(Тип) = Тип("ОписаниеТипов") И Тип.Типы().Количество() > 0, Тип.Типы()[0], Тип);
		Если ЭтотТипНеВходитВБРО(ТипСоздаваемогоОбъекта) Тогда
			Если СозданиеСообщения Тогда
				СтандартнаяОбработка = Истина;
				РегламентированнаяОтчетностьКлиентПереопределяемый.СоздатьНовыйОбъект(Организация, ТипСоздаваемогоОбъекта, СтандартнаяОбработка);
				Если СтандартнаяОбработка Тогда
					// Создаем объект
					
					Если ТипСоздаваемогоОбъекта = Тип("ДокументСсылка.ЗаявленияПоЭлДокументооборотуСПФР") Тогда
						
						Если Строка(ПредопределенноеЗначение("Перечисление.ВидыЗаявленийНаЭДОВПФР.НаОтключение")) = Наименование Тогда
							Вид = ПредопределенноеЗначение("Перечисление.ВидыЗаявленийНаЭДОВПФР.НаОтключение");
						ИначеЕсли Строка(ПредопределенноеЗначение("Перечисление.ВидыЗаявленийНаЭДОВПФР.НаСертификат")) = Наименование Тогда
							Вид = ПредопределенноеЗначение("Перечисление.ВидыЗаявленийНаЭДОВПФР.НаСертификат");
						Иначе
							Вид = ПредопределенноеЗначение("Перечисление.ВидыЗаявленийНаЭДОВПФР.НаПодключение");
						КонецЕсли;
						
						ДокументооборотСКОКлиент.СоздатьНовоеИлиОткрытьЗаявлениеВПФР(Вид, Организация);
						
					Иначе
						ИмяОбъектаМетаданных = ПолноеИмяОбъектаМетаданных(ТипСоздаваемогоОбъекта);
						ОткрытьФорму(ИмяОбъектаМетаданных + ".ФормаОбъекта", 
							Новый Структура("Организация, Данные", Организация, Данные), ЭтотОбъект.ВладелецФормы);
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыЗакрытия = Новый Структура();
		ПараметрыЗакрытия.Вставить("Тип", 			Тип);
		ПараметрыЗакрытия.Вставить("Наименование", 	Наименование);
		
		Закрыть(ПараметрыЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолучитьИдентификаторНужногоЭлемента(Элементы, ВидУведомления, Идентификатор)

	Для каждого Элемент из Элементы Цикл
		
		Если Элемент.Тип = ВидУведомления Тогда
			Идентификатор = Элемент.ПолучитьИдентификатор();
			Возврат;
		Конецесли;
		
		ПолучитьИдентификаторНужногоЭлемента(Элемент.ПолучитьЭлементы(), ВидУведомления, Идентификатор);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НаложитьОтборы()
	Элементы.Выбрать.Доступность = ЗначениеЗаполнено(Организация);
	Если ВидыСообщенийИП.Количество() > 0 Тогда
		СформироватьСписок();
	ИначеЕсли Организация <> ОрганизацияПредидущийВыбор
		Или ПолучитьХеш(Поиск) <> ПрошлыйХеш Тогда
		
		Если Элементы.ВидыСообщений.ТекущиеДанные = Неопределено Тогда 
			ПерестроитьДерево(Неопределено);
		Иначе 
			ПерестроитьДерево(Элементы.ВидыСообщений.ТекущиеДанные.Тип);
		КонецЕсли;
		РазвернутьДеревоПослеФильтрации();
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьХеш(Стр)
	Хеш = СтрЗаменить(НРег(Стр), " ", "");
	Хеш = СтрЗаменить(Хеш, """", "");
	Хеш = СтрЗаменить(Хеш, ",", "");
	Возврат Хеш;
КонецФункции

&НаКлиенте
Процедура РазвернутьДеревоПослеФильтрации()
	ВсегоГрупп = 0;
	Для Каждого Стр Из ВидыСообщений.ПолучитьЭлементы() Цикл 
		ВсегоГрупп = ВсегоГрупп + ?(Стр.ПолучитьЭлементы().Количество() > 0, 1, 0);
	КонецЦикла;
	Если ВсегоГрупп <= 3 Тогда 
		Для Каждого Стр Из ВидыСообщений.ПолучитьЭлементы() Цикл
			РазвернутьСтроку(Стр);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьСтроку(Строка)
	Для Каждого Стр Из Строка.ПолучитьЭлементы() Цикл 
		РазвернутьСтроку(Стр);
	КонецЦикла;
	Элементы.ВидыСообщений.Развернуть(Строка.ПолучитьИдентификатор());
КонецПроцедуры

&НаСервере
Процедура ФильтроватьСтроки(СтрокиДерева, Организация, Хеш, ЭтоЮЛ, ТермыПоиска)
	КС = СтрокиДерева.Количество();
	Пока КС > 0 Цикл 
		КС = КС - 1;
		Стр = СтрокиДерева[КС];
		Если Стр.ПолучитьЭлементы().Количество() = 0 Тогда
			Если ЗначениеЗаполнено(Хеш) И СтрНайти(Стр.Хеш, Хеш) = 0 Тогда 
				Найдено = Ложь; НеНайдено = Ложь;
				Для Каждого Терм Из ТермыПоиска Цикл
					Если СтрНачинаетсяС(Терм, "-") Тогда 
						Если СтрНайти(Стр.Хеш, СтрЗаменить(Терм, "-", "")) > 0 Тогда 
							НеНайдено = Истина;
						КонецЕсли;
					ИначеЕсли СтрНайти(Стр.Хеш, Терм) = 0 Тогда 
						НеНайдено = Истина;
					Иначе
						Найдено = Истина;
					КонецЕсли;
				КонецЦикла;
				
				Если НеНайдено Или Не Найдено Тогда 
					СтрокиДерева.Удалить(Стр);
				ИначеЕсли ЗначениеЗаполнено(Организация) И ТипЗнч(Стр.Тип) = Тип("ПеречислениеСсылка.ВидыУведомленийОСпецрежимахНалогообложения") Тогда 
					Если (ЭтоЮЛ И Не ДанноеСообщениеДоступноДляОрганизации(Стр.Тип))
						Или (Не ЭтоЮЛ И Не ДанноеСообщениеДоступноДляИП(Стр.Тип)) Тогда 
						СтрокиДерева.Удалить(Стр);
					КонецЕсли;
				КонецЕсли;
			ИначеЕсли ЗначениеЗаполнено(Организация) И ТипЗнч(Стр.Тип) = Тип("ПеречислениеСсылка.ВидыУведомленийОСпецрежимахНалогообложения") Тогда 
				Если (ЭтоЮЛ И Не ДанноеСообщениеДоступноДляОрганизации(Стр.Тип))
					Или (Не ЭтоЮЛ И Не ДанноеСообщениеДоступноДляИП(Стр.Тип)) Тогда 
					СтрокиДерева.Удалить(Стр);
				КонецЕсли;
			КонецЕсли;
		Иначе
			ФильтроватьСтроки(Стр.ПолучитьЭлементы(), Организация, Хеш, ЭтоЮЛ, ТермыПоиска);
			Если Стр.ПолучитьЭлементы().Количество() = 0 Тогда 
				СтрокиДерева.Удалить(Стр);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
