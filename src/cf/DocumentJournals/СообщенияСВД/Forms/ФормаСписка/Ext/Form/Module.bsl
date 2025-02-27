﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ГруппироватьПоСессиям = ХранилищеНастроекДанныхФорм.Загрузить("СообщенияСВД", "ГруппироватьПоСессиям");
	ГруппироватьПоСессиям = Ложь;
	Если ГруппироватьПоСессиям = Неопределено Тогда
		ГруппироватьПоСессиям = Ложь;
	КонецЕсли;
	ГруппироватьПоСессиям();
	
КонецПроцедуры

&НаСервере
Процедура ГруппироватьПоСессиям()
	
	Элементы.ФормаГруппировкаПоСессиям.Пометка = Ложь;
	Список.Группировка.Элементы.Очистить();
	Если ГруппироватьПоСессиям Тогда
		ПолеГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Сессия");
		ПолеГруппировки.Использование = Истина;
		Элементы.ФормаГруппировкаПоСессиям.Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПоСессиям(Команда)
	
	ГруппироватьПоСессиям = НЕ ГруппироватьПоСессиям;	
	ГруппироватьПоСессиям();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииСервер()
	
	ХранилищеНастроекДанныхФорм.Сохранить("СообщенияСВД", "ГруппироватьПоСессиям", ГруппироватьПоСессиям);
	
КонецПроцедуры
