﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДерево();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДерево()
	
	Дерево = РеквизитФормыВЗначение("ВизыСогласования");
	Дерево.Строки.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВизыСогласования.Ссылка,
	|	ВизыСогласования.ПометкаУдаления,
	|	ВизыСогласования.Документ,
	|	ВизыСогласования.Исполнитель,
	|	ВизыСогласования.ПомещенаВИсторию,
	|	ВизыСогласования.ДатаПомещенияВИсторию КАК ДатаПомещенияВИсторию,
	|	ВизыСогласования.Удалена,
	|	ВизыСогласования.РезультатСогласования,
	|	ВизыСогласования.Комментарий,
	|	ВизыСогласования.ДатаИсполнения,
	|	ВизыСогласования.Автор,
	|	ВизыСогласования.ПоместилВИсторию КАК ПоместилВИсторию,
	|	ВизыСогласования.УстановилРезультат,
	|	ВизыСогласования.Источник
	|ИЗ
	|	Справочник.ВизыСогласования КАК ВизыСогласования
	|ГДЕ
	|	ВизыСогласования.ПомещенаВИсторию = ИСТИНА
	|	И ВизыСогласования.ПометкаУдаления = ЛОЖЬ
	|	И ВизыСогласования.Удалена = ЛОЖЬ
	|	И ВизыСогласования.Документ = &Документ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаПомещенияВИсторию УБЫВ
	|ИТОГИ ПО
	|	ДатаПомещенияВИсторию,
	|	ПоместилВИсторию";
	
	Запрос.УстановитьПараметр("Документ", Параметры.Документ);
	
	ВыборкаДата = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДата.Следующий() Цикл 
		ВыборкаПоместил = ВыборкаДата.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоместил.Следующий() Цикл
			РодительскаяСтрока = Дерево.Строки.Добавить();
			РодительскаяСтрока.Исполнитель = Формат(ВыборкаПоместил.ДатаПомещенияВИсторию, "ДЛФ=D") + " (" + Строка(ВыборкаПоместил.ПоместилВИсторию) + ")";
			РодительскаяСтрока.ГруппаСтрок = Истина;
			
			ВыборкаДетали = ВыборкаПоместил.Выбрать();
			Пока ВыборкаДетали.Следующий() Цикл
				НоваяСтрока = РодительскаяСтрока.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетали);
			КонецЦикла;
		КонецЦикла;	
	КонецЦикла;	
	
	ЗначениеВРеквизитФормы(Дерево, "ВизыСогласования");
	
КонецПроцедуры


&НаКлиенте
Процедура ВизыСогласованияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ВизыСогласования.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ГруппаСтрок Тогда 
		Возврат;
	КонецЕсли;	
	
	ПоказатьЗначение(,ТекущиеДанные.Ссылка);
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры


&НаКлиенте
Процедура ВизыСогласованияПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ВизыСогласования.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ГруппаСтрок Тогда 
		Возврат;
	КонецЕсли;	
	
	ПоказатьЗначение(,ТекущиеДанные.Ссылка);
	
	Отказ = Истина;
	
КонецПроцедуры


&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьДерево();
	
	КоллекцияСтрок = ВизыСогласования.ПолучитьЭлементы();
	Для Каждого Строка Из КоллекцияСтрок Цикл
		ИдентификаторСтроки = Строка.ПолучитьИдентификатор();
		Элементы.ВизыСогласования.Развернуть(ИдентификаторСтроки, Истина)
	КонецЦикла;
	
КонецПроцедуры
