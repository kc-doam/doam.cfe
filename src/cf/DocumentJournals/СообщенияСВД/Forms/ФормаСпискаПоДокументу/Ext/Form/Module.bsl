﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор,
		"Документ",
		Параметры.Документ);
		
	Если ТипЗнч(Параметры.Документ) = Тип("СправочникСсылка.ИсходящиеДокументы")
		И Параметры.Документ.Получатели.Количество() = 1
		Или ТипЗнч(Параметры.Документ) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
		Элементы.ГруппаАдресаты.Видимость = Ложь;
	КонецЕсли;
			
КонецПроцедуры
