﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей Нумераторов
//
// Возвращаемое значение:
//   Структура
//     Наименование
//     Периодичность
//     ФорматНомера
//     НезависимаяНумерацияПоОрганизациям
//     НезависимаяНумерацияПоПодразделению
//     НезависимаяНумерацияПоВидуДокумента
//     НезависимаяНумерацияПоПроекту
//     НезависимаяНумерацияПоВопросуДеятельности
//     ТипСвязи
//
Функция ПолучитьСтруктуруНумераторов() Экспорт
	
	ПараметрыНумераторов = Новый Структура;
	ПараметрыНумераторов.Вставить("Наименование");
	ПараметрыНумераторов.Вставить("Периодичность");
	ПараметрыНумераторов.Вставить("ФорматНомера");
	ПараметрыНумераторов.Вставить("НезависимаяНумерацияПоОрганизациям");
	ПараметрыНумераторов.Вставить("НезависимаяНумерацияПоСвязанномуДокументу");
	ПараметрыНумераторов.Вставить("НезависимаяНумерацияПоПодразделению");
	ПараметрыНумераторов.Вставить("НезависимаяНумерацияПоВидуДокумента");
	ПараметрыНумераторов.Вставить("НезависимаяНумерацияПоПроекту");
	ПараметрыНумераторов.Вставить("НезависимаяНумерацияПоВопросуДеятельности");
	ПараметрыНумераторов.Вставить("ТипСвязи");
	
	Возврат ПараметрыНумераторов;
	
КонецФункции

// Создает и записывает в БД Нумератор
//
// Параметры:
//   СтруктураНумератора - Структура - структура полей нумераторов.
//
Функция СоздатьНумератор(СтруктураНумератора) Экспорт
	
	НовыйНумератор = СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовыйНумератор, СтруктураНумератора);
	НовыйНумератор.Записать();
	
	Возврат НовыйНумератор.Ссылка;
	
КонецФункции

#КонецОбласти

#КонецЕсли