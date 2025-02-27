﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяСохраняемогоПараметра = Параметры.ИмяСохраняемогоПараметра;
	ЗначениеНеПоказывать     = Параметры.ЗначениеНеПоказывать;
	
	Если Параметры.РежимОткрытия = "Принудительно" Тогда
		Элементы.БольшеНеПоказывать.Видимость = Ложь;
		Элементы.ПоказатьПозже.Заголовок = "Закрыть";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокФормы) Тогда
		ЭтотОбъект.Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
	
	ИмяРодительскогоОтчета = Лев(ИмяСохраняемогоПараметра, СтрНайти(ИмяСохраняемогоПараметра, "_") - 1);
	РодительскийОтчет = Отчеты[ИмяРодительскогоОтчета];
	ИмяМакетаИнформации = Сред(ИмяСохраняемогоПараметра, СтрНайти(ИмяСохраняемогоПараметра, "_") + 1);
	
	ПолеОписанияИзменений = РодительскийОтчет.ПолучитьМакет(ИмяМакетаИнформации).ПолучитьТекст();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеОписанияИзмененийПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ДанныеСобытия.Anchor <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		СсылкаИзОписанияИзменений = ДанныеСобытия.Anchor.href;
		
		ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПопытатьсяПерейтиПоНавигационнойСсылке(
			СсылкаИзОписанияИзменений);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура БольшеНеПоказывать(Команда)
	
	Сохранить();
	
	Если НЕ ВладелецФормы = Неопределено Тогда
		ВладелецФормы.Активизировать();
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПозже(Команда)
	
	Если НЕ ВладелецФормы = Неопределено Тогда
		ВладелецФормы.Активизировать();
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура Сохранить()
	
	ХранилищеНастроекДанныхФорм.Сохранить(
		"Отчет.РегламентированныйОтчетБухОтчетность.Форма.УведомлениеОбИзменениях",
		ИмяСохраняемогоПараметра, ЗначениеНеПоказывать);
	
КонецПроцедуры

#КонецОбласти
